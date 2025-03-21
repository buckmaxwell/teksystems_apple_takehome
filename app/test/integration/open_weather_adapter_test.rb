# test/integration/open_weather_adapter_test.rb
require "test_helper"

class OpenWeatherAdapterTest < ActiveSupport::TestCase
  test "fetches and parses real API data" do
    lat = "39.9612"
    lon = "-82.9988"

    result = OpenWeatherAdapter.fetch(lat: lat, lon: lon)

    assert result[:temperature]
    assert result[:forecast]
    assert result[:weather_code]
  end
end
