module Echo
  class Configuration
    property websoket_uri = "ws://localhost:4000/hi"
    property redis : MiniRedis = MiniRedis.new(
      uri: URI.parse(ENV["REDIS_URL"])
    )
  end
end
