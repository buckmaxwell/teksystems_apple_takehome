class WeatherController < ApplicationController
  require "net/http"

  def show
    zip_code = params[:zip]
    lat = params[:lat]
    lon = params[:lon]

    if zip_code.blank? || lat.blank? || lon.blank?
      return render json: { error: "Missing zip, lat, or lon" }, status: :bad_request
    end

    weather_data = fetch_weather(zip_code, lat, lon)

    if weather_data
      render json: weather_data
    else
      render json: { error: "Could not fetch weather data" }, status: :service_unavailable
    end
  end

  private

  def fetch_weather(zip_code, lat, lon)
    api_key = Rails.application.credentials.openweather_api_key
    return nil unless api_key

    url = URI("https://api.openweathermap.org/data/3.0/onecall?lat=#{lat}&lon=#{lon}&units=imperial&exclude=minutely,hourly,alerts&appid=#{api_key}")

    response = Net::HTTP.get_response(url)

    return nil unless response.is_a?(Net::HTTPSuccess)

    json = JSON.parse(response.body)

    {
      temperature: json.dig("current", "temp"),
      high: json.dig("daily", 0, "temp", "max"),
      low: json.dig("daily", 0, "temp", "min"),

      forecast: json.dig("current", "weather", 0, "description")&.capitalize
    }
  rescue StandardError => e
    Rails.logger.error "Weather API Error: #{e.message}"
    nil
  end
end
