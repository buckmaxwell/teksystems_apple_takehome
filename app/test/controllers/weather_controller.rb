require "test_helper"

class WeatherControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valid_params = {
      zip: "43215",
      lat: "39.9612",
      lon: "-82.9988"
    }

    @weather_data = {
      temperature: 70.0,
      high: 75.0,
      low: 65.0,
      forecast: "Clear sky",
      weather_code: 800,
      background_image: "/assets/clear_sky.jpg"
    }
  end

  test "returns cached data if available" do
    WeatherCacheService.stub :fetch, @weather_data.merge("cached" => true) do
      get "/forecast", params: @valid_params

      assert_response :success
      body = JSON.parse(response.body)
      assert_equal "Clear sky", body["forecast"]
      assert_equal true, body["cached"]
    end
  end

  test "fetches data from service and stores it if cache is empty" do
    WeatherCacheService.stub :fetch, nil do
      WeatherService.stub :get_weather, @weather_data do
        stored = Minitest::Mock.new
        stored.expect(:call, nil, [ @valid_params[:zip], @weather_data ])

        WeatherCacheService.stub :store, stored do
          get "/forecast", params: @valid_params

          assert_response :success
          body = JSON.parse(response.body)
          assert_equal "Clear sky", body["forecast"]
          stored.verify
        end
      end
    end
  end

  test "returns 400 for invalid params" do
    get "/forecast", params: { zip: "", lat: "", lon: "" }

    assert_response :bad_request
    assert_includes JSON.parse(response.body)["error"], "can't be blank"
  end

  test "returns 503 if weather service fails" do
    WeatherCacheService.stub :fetch, nil do
      WeatherService.stub :get_weather, nil do
        get "/forecast", params: @valid_params

        assert_response :service_unavailable
        assert_equal "Could not fetch weather data", JSON.parse(response.body)["error"]
      end
    end
  end
end
