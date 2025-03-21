require "test_helper"

class WeatherCacheServiceTest < ActiveSupport::TestCase
  def setup
    @zip = "12345"
    Redis.new(url: ENV["REDIS_URL"]).del("weather:#{@zip}") # clear before test
  end

  test "returns nil when cache is empty" do
    assert_nil WeatherCacheService.fetch(@zip)
  end

  test "can store and fetch cached weather data" do
    data = { temperature: 70, forecast: "Sunny" }
    WeatherCacheService.store(@zip, data)
    result = WeatherCacheService.fetch(@zip)

    assert_equal data.stringify_keys.merge("cached" => true), result
  end
end
