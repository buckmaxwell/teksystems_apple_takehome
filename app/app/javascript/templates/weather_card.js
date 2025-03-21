export function renderWeatherCard(weather, locationName) {
  const cachedIndicator = weather.cached
    ? `<p class="text-[10px] text-gray-400 mt-1 text-right">⚡ Loaded from cache</p>`
    : "";

  return `
    <div class="relative rounded-lg overflow-hidden shadow-lg">
      <div class="absolute inset-0 bg-black/50"></div> <!-- Dark overlay -->
      <div class="relative p-4 text-white">
        <h2 class="text-lg font-semibold">${locationName}</h2>
        <p>Temperature: ${weather.temperature}°F</p>
        <p>High: ${weather.high}°F, Low: ${weather.low}°F</p>
        <p>Forecast: ${weather.forecast}</p>
        ${cachedIndicator}
      </div>
    </div>`;
}
