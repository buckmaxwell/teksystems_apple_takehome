class WeatherService
  def self.get_weather(zip_code, lat, lon)
    data = call_adapter(lat: lat, lon: lon)
    return unless data

    data.merge(
      background_image: ActionController::Base.helpers.asset_path(
        image_for(data[:weather_code])
      )
    )
  end

  def self.call_adapter(lat:, lon:)
    OpenWeatherAdapter.fetch(lat: lat, lon: lon)
  end

  def self.image_for(code)
    case code
    when 200..232 then "heavy_rain.jpg"
    when 300..531 then "light_rain.jpg"
    when 600..622 then "snowy.jpg"
    when 701..781 then "foggy.jpg"
    when 800       then "clear_sky.jpg"
    when 801..802  then "partly_cloudy.jpg"
    when 803..804  then "overcast.jpg"
    else               "clear_sky.jpg"
    end
  end
end
