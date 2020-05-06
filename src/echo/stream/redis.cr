require "mini_redis"
require "suzuri"

module Echo
  class Redis(E, C) 
    include Stream(E, C)
    getter consumers = Set(C).new

    @key : String = UUID.random.hexstring
    @channel = Channel(E).new

    def initialize(@name : String)
      @redis = MiniRedis.new
      spawn { listen }
      
    end

    def subscribe(consumer : C)
      @consumers << consumer
    end

    def unsubscribe(consumer : C)
      consumers.delete consumer
    end

    def publish(event : E)
      token= event.to_json
      spawn { @redis.send("XADD", @name , "*", "msg", token) }
      event
    end

    private def listen
      loop do
        response = @redis.send("XREAD","COUNT", "1", "BLOCK", "0", "STREAMS", @name, "$").raw.as(Array)
        stream = response[0].raw.as(Array)[1]
        msg = stream.raw.as(Array)[0].raw.as(Array).last.raw.as(Array).last.raw.as(Bytes)
        event = (E).from_json(String.new(msg))

        p "Hello from listening"
        @channel.send event
      end
    end

    private def consume
      p "hello from consume"
      event = @channel.receive
      p @consumers.size
      @consumers.each { |consumer| consumer.on event }
    end
  end
end