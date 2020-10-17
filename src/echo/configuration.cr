module Echo
  class Configuration
    property websoket_uri = "ws://localhost:4000/hi"
    property redis : MiniRedis

    def initialize
      @redis = MiniRedis.new uri: URI.parse(redis_url)
    end

    def redis_url
      ENV.fetch "REDIS_URL", "redis://localhost:6379"
    end
  end
end
