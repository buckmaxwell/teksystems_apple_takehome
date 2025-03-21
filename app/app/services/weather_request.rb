class WeatherRequest
  include ActiveModel::Model

  attr_accessor :zip_code, :lat, :lon

  validates :lat, :lon, presence: true
  validates :zip_code, presence: true, length: { is: 5 }, numericality: { only_integer: true }

  def initialize(params)
    @zip_code = params[:zip]
    @lat = params[:lat]
    @lon = params[:lon]
  end
end
