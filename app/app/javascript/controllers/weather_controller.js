import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "results", "weather"];

  connect() {
    this.apiKey = document.querySelector("meta[name='google-api-key']").content;
    this.selectedLocation = null;
  }

  async fetchSuggestions() {
    const query = this.inputTarget.value.trim();
    if (query.length < 3) {
      this.resultsTarget.innerHTML = "";
      this.resultsTarget.classList.add("hidden");
      return;
    }

    const response = await fetch(
      "https://places.googleapis.com/v1/places:searchText",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Goog-Api-Key": this.apiKey,
          "X-Goog-FieldMask":
            "places.displayName,places.shortFormattedAddress,places.addressComponents,places.location",
        },
        body: JSON.stringify({ textQuery: query }),
      }
    );

    const data = await response.json();
    this.updateAutocompleteResults(data.places ? data.places.slice(0, 5) : []);
  }

  updateAutocompleteResults(results) {
    this.resultsTarget.innerHTML = "";

    if (results.length === 0) {
      this.resultsTarget.classList.add("hidden");
      return;
    }

    results.forEach((place) => {
      const displayText = place.shortFormattedAddress || "Unknown Address";
      const zipCode = this.extractZipCode(place);
      const lat = place.location?.latitude;
      const lon = place.location?.longitude;

      const li = document.createElement("li");
      li.textContent = displayText;
      li.dataset.zip = zipCode;
      li.dataset.lat = lat;
      li.dataset.lon = lon;
      li.dataset.action = "click->weather#selectSuggestion";
      li.className = "px-4 py-2 cursor-pointer hover:bg-gray-100";
      this.resultsTarget.appendChild(li);
    });

    this.resultsTarget.classList.remove("hidden");
  }

  selectSuggestion(event) {
    this.inputTarget.value = event.target.textContent;
    this.selectedLocation = {
      zip: event.target.dataset.zip,
      lat: event.target.dataset.lat,
      lon: event.target.dataset.lon,
    };
    this.resultsTarget.innerHTML = "";
    this.resultsTarget.classList.add("hidden");
  }

  async submitForm(event) {
    event.preventDefault();

    if (!this.selectedLocation || !this.selectedLocation.zip) {
      alert("Please select an address from the suggestions.");
      return;
    }

    const { zip, lat, lon } = this.selectedLocation;
    const response = await fetch(`/forecast?zip=${zip}&lat=${lat}&lon=${lon}`);
    const weather = await response.json();
    const cachedIndicator = weather.cached
      ? `<p class="text-[10px] text-gray-400 mt-1 text-right">⚡ Loaded from cache</p>`
      : "";

    // Only show weather result if there's valid data
    if (weather.temperature) {
      this.weatherTarget.classList.remove("hidden"); // Make it visible
      // Update weather details

      this.weatherTarget.innerHTML = `
	    <div class="relative rounded-lg overflow-hidden shadow-lg">
	      <div class="absolute inset-0 bg-black/50"></div> <!-- Dark overlay -->
	      <div class="relative p-4 text-white">
		<h2 class="text-lg font-semibold">${this.inputTarget.value}</h2>
		<p>Temperature: ${weather.temperature}°F</p>
		<p>High: ${weather.high}°F, Low: ${weather.low}°F</p>
		<p>Forecast: ${weather.forecast}</p>
		${cachedIndicator}
	      </div>
	    </div>`;
    } else {
      this.weatherTarget.classList.add("hidden"); // Hide if no data
    }

    this.updateBackground(weather.background_image);
  }

  extractZipCode(place) {
    if (!place.addressComponents) return null;
    for (let component of place.addressComponents) {
      if (component.types.includes("postal_code")) {
        return component.longText;
      }
    }
    return null;
    this.updateBackground(weather.background_image);
  }

  updateBackground(imageUrl) {
    this.weatherTarget.style.backgroundImage = `url(${imageUrl})`;
    this.weatherTarget.style.backgroundSize = "cover";
    this.weatherTarget.style.backgroundPosition = "center";
    this.weatherTarget.style.backgroundRepeat = "no-repeat";
    this.weatherTarget.style.color = "white"; // Ensure text remains readable
    console.log("Updated weather background");
  }
}
