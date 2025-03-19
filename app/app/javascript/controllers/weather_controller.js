import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "results", "weather"];

  connect() {
    this.apiKey = document.querySelector("meta[name='google-api-key']").content;
    this.selectedZipCode = null;
  }

  async fetchSuggestions() {
    const query = this.inputTarget.value.trim();
    if (query.length < 3) {
      this.resultsTarget.innerHTML = "";
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
            "places.displayName,places.formattedAddress,places.addressComponents,places.shortFormattedAddress",
        },
        body: JSON.stringify({ textQuery: query }),
      }
    );

    const data = await response.json();
    this.updateAutocompleteResults(data.places ? data.places.slice(0, 5) : []);
  }

  updateAutocompleteResults(results) {
    this.resultsTarget.innerHTML = ""; // Clear previous results

    results.forEach((place) => {
      const displayText = place.shortFormattedAddress || "Unknown Address";

      const li = document.createElement("li");
      li.textContent = displayText;
      li.dataset.zip = this.extractZipCode(place);
      li.dataset.action = "click->weather#selectSuggestion";
      this.resultsTarget.appendChild(li);
    });
  }

  selectSuggestion(event) {
    this.inputTarget.value = event.target.textContent;
    this.selectedZipCode = event.target.dataset.zip;
    this.resultsTarget.innerHTML = ""; // Clear dropdown
  }

  async submitForm(event) {
    event.preventDefault();

    if (!this.selectedZipCode) {
      alert("Please select an address from the suggestions.");
      return;
    }

    const response = await fetch(`/forecast?zip=${this.selectedZipCode}`);
    const weather = await response.json();
    this.weatherTarget.innerHTML = `
      <h2>Weather for ZIP ${this.selectedZipCode}</h2>
      <p>Temperature: ${weather.temperature}°F</p>
      <p>High: ${weather.high}°F, Low: ${weather.low}°F</p>
      <p>Forecast: ${weather.forecast}</p>
    `;
  }

  extractZipCode(place) {
    if (!place.addressComponents) return null;
    for (let component of place.addressComponents) {
      if (component.types.includes("postal_code")) {
        return component.longText;
      }
    }
    return null;
  }
}
