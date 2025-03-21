class WeatherCacheService
  CACHE_EXPIRY = 30.minutes
  require "redis"


  def self.redis
    @redis ||= Redis.new(url: ENV["REDIS_URL"])
  end

  def self.fetch(zip_code)
    cached = redis.get(cache_key(zip_code))
    return unless cached

    JSON.parse(cached).merge("cached" => true)
  end

  def self.store(zip_code, data)
    redis.setex(cache_key(zip_code), CACHE_EXPIRY.to_i, data.to_json)
  end

  def self.cache_key(zip_code)
    "weather:#{zip_code}"
  end
end
