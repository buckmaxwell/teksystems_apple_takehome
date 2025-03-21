export async function fetchPlaceSuggestions(query, apiKey) {
  const response = await fetch(
    "https://places.googleapis.com/v1/places:searchText",
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": apiKey,
        "X-Goog-FieldMask":
          "places.displayName,places.shortFormattedAddress,places.addressComponents,places.location",
      },
      body: JSON.stringify({ textQuery: query }),
    }
  );

  const data = await response.json();
  return data.places || [];
}

export function extractZipLatLon(place) {
  const zipComponent = place.addressComponents?.find((c) =>
    c.types.includes("postal_code")
  );
  const zip = zipComponent?.longText;
  const lat = place.location?.latitude;
  const lon = place.location?.longitude;
  return { zip, lat, lon };
}
