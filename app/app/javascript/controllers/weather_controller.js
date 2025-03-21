import { Controller } from "@hotwired/stimulus";
import { fetchPlaceSuggestions, extractZipLatLon } from "utils/google_places";
import { renderWeatherCard } from "templates/weather_card";

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

    const places = await fetchPlaceSuggestions(query, this.apiKey);
    this.updateAutocompleteResults(places);
  }

  updateAutocompleteResults(places) {
    this.resultsTarget.innerHTML = "";

    if (!places || places.length === 0) {
      this.resultsTarget.classList.add("hidden");
      return;
    }

    places.forEach((place) => {
      const { zip, lat, lon } = extractZipLatLon(place);
      const li = document.createElement("li");
      li.textContent = place.shortFormattedAddress || "Unknown Address";
      li.dataset.zip = zip || "";
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
    const { zip, lat, lon } = this.selectedLocation || {};
    if (!zip || !lat || !lon) {
      alert("Please select an address from the suggestions.");
      return;
    }

    const response = await fetch(`/forecast?zip=${zip}&lat=${lat}&lon=${lon}`);
    const weather = await response.json();

    if (weather.temperature) {
      this.weatherTarget.classList.remove("hidden");
      this.weatherTarget.innerHTML = renderWeatherCard(
        weather,
        this.inputTarget.value
      );
      this.updateBackground(weather.background_image);
    } else {
      this.weatherTarget.classList.add("hidden");
    }
  }

  updateBackground(imageUrl) {
    this.weatherTarget.style.backgroundImage = `url(${imageUrl})`;
    this.weatherTarget.style.backgroundSize = "cover";
    this.weatherTarget.style.backgroundPosition = "center";
    this.weatherTarget.style.backgroundRepeat = "no-repeat";
    this.weatherTarget.style.color = "white";
  }
}
