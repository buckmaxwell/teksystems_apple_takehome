require "test_helper"
require "minitest/mock"

class WeatherServiceTest < ActiveSupport::TestCase
  setup do
    @zip = "43215"
    @lat = "39.9612"
    @lon = "-82.9988"

    @mock_response = {
      temperature: 55.2,
      high: 58.0,
      low: 50.0,
      forecast: "Clear sky",
      weather_code: 800
    }
  end

  test "returns decorated weather data with background image" do
    WeatherService.stub :call_adapter, proc { |_zip, _lat, _lon| @mock_response } do
      result = WeatherService.get_weather(@zip, @lat, @lon)

      assert_not_nil result
      assert_equal 55.2, result[:temperature]
      assert_equal 58.0, result[:high]
      assert_equal 50.0, result[:low]
      assert_equal "Clear sky", result[:forecast]
      assert_equal 800, result[:weather_code]
      assert_match(/clear_sky.*\.jpg$/, result[:background_image])
    end
  end

  test "returns nil if adapter fails" do
    WeatherService.stub :call_adapter, proc { |_zip, _lat, _lon| nil } do
      result = WeatherService.get_weather(@zip, @lat, @lon)
      assert_nil result
    end
  end

  test "image_for returns correct images based on weather code" do
    assert_equal "heavy_rain.jpg", WeatherService.image_for(202)
    assert_equal "light_rain.jpg", WeatherService.image_for(310)
    assert_equal "snowy.jpg", WeatherService.image_for(615)
    assert_equal "foggy.jpg", WeatherService.image_for(741)
    assert_equal "clear_sky.jpg", WeatherService.image_for(800)
    assert_equal "partly_cloudy.jpg", WeatherService.image_for(802)
    assert_equal "overcast.jpg", WeatherService.image_for(804)
    assert_equal "clear_sky.jpg", WeatherService.image_for(999) # fallback
  end
end
