class WeatherController < ApplicationController
  def show
    request = WeatherRequest.new(params)

    unless request.valid?
      return render json: { error: request.errors.full_messages.to_sentence }, status: :bad_request
    end

    weather_data = WeatherCacheService.fetch(request.zip_code)

    unless weather_data
      weather_data = WeatherService.get_weather(request.zip_code, request.lat, request.lon)
      WeatherCacheService.store(request.zip_code, weather_data) if weather_data
    end

    if weather_data
      render json: weather_data
    else
      render json: { error: "Could not fetch weather data" }, status: :service_unavailable
    end
  end
end
