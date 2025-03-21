require "test_helper"

class WeatherRequestTest < ActiveSupport::TestCase
  test "is valid with valid zip, lat, and lon" do
    request = WeatherRequest.new(zip: "43215", lat: "39.9612", lon: "-82.9988")
    assert request.valid?
  end

  test "is invalid without lat" do
    request = WeatherRequest.new(zip: "43215", lon: "-82.9988")
    assert_not request.valid?
    assert_includes request.errors[:lat], "can't be blank"
  end

  test "is invalid without lon" do
    request = WeatherRequest.new(zip: "43215", lat: "39.9612")
    assert_not request.valid?
    assert_includes request.errors[:lon], "can't be blank"
  end

  test "is invalid without zip" do
    request = WeatherRequest.new(lat: "39.9612", lon: "-82.9988")
    assert_not request.valid?
    assert_includes request.errors[:zip_code], "can't be blank"
  end

  test "is invalid with non-numeric zip" do
    request = WeatherRequest.new(zip: "abcde", lat: "39.9612", lon: "-82.9988")
    assert_not request.valid?
    assert_includes request.errors[:zip_code], "is not a number"
  end

  test "is invalid with zip code of wrong length" do
    request = WeatherRequest.new(zip: "123", lat: "39.9612", lon: "-82.9988")
    assert_not request.valid?
    assert_includes request.errors[:zip_code], "is the wrong length (should be 5 characters)"
  end
end
