module Echo
  class Configuration
    property websoket_uri = "ws://localhost:4000/hi"
    property redis : ::Redis::PooledClient

    def initialize
      @redis = ::Redis::PooledClient.new(
        host: ENV.fetch("REDIS_HOST", "localhost"),
        port: ENV.fetch("REDIS_PORT", "6379").to_i,
        password: ENV.fetch("REDIS_PASSWORD", nil),
        pool_size: ENV.fetch("REDIS_POOL_SIZE", "50").to_i,
        pool_timeout: ENV.fetch("REDIS_TIMEOUT", "0.2").to_f
      )
    end
  end
end
