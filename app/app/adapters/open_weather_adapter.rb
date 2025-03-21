require "net/http"
require "json"

class OpenWeatherAdapter
  BASE_URL = "https://api.openweathermap.org/data/3.0/onecall"

  def self.fetch(lat:, lon:)
    api_key = Rails.application.credentials.openweather_api_key
    return nil unless api_key

    url = URI("#{BASE_URL}?lat=#{lat}&lon=#{lon}&units=imperial&exclude=minutely,hourly,alerts&appid=#{api_key}")
    response = Net::HTTP.get_response(url)

    return nil unless response.is_a?(Net::HTTPSuccess)

    json = JSON.parse(response.body)

    {
      temperature: json.dig("current", "temp"),
      high:        json.dig("daily", 0, "temp", "max"),
      low:         json.dig("daily", 0, "temp", "min"),
      forecast:    json.dig("current", "weather", 0, "description")&.capitalize,
      weather_code: json.dig("current", "weather", 0, "id")
    }
  rescue StandardError => e
    Rails.logger.error "OpenWeatherAdapter Error: #{e.message}"
    nil
  end
end
