require "mini_redis"
require "suzuri"

# http://crystal-lang.org
module Echo
  class Redis(E, C)
    include Stream(E, C)
    property from : String
    getter consumers = Set(C).new
    @key : String = UUID.random.hexstring
    
    def initialize(@name : String, @from : String =  (Time.utc.to_unix_ms - 1).to_s)
      @redis = MiniRedis.new
    end

    def subscribe(consumer : C)
      @consumers << consumer
    end

    def unsubscribe(consumer : C)
      consumers.delete consumer
    end

    def publish(event : E)
      @redis.send("XADD", @name, "*", "msg", Base64.urlsafe_encode(event.to_json))
      spawn distribute(@from, consumers)
      event
    end

    def distribute(since last_message_id, to consumers)
      response = @redis.send("XREAD", "COUNT", "100", "BLOCK", "0", "STREAMS", @name, "#{last_message_id}" )
      streams = response.raw.as(Array).first.raw.as(Array)
      events = xread_parser(streams)
      spawn broadcast(events, consumers, last_message_id)
    end

    private def xread_parser(payload, keys = Array(String).new, values = Array(E).new)
      payload.each do |stream|
        case raw = stream.raw
        when Array(MiniRedis::Value) 
          xread_parser(raw, keys, values)
        when Bytes 
          val = String.new(raw)
          next if val.starts_with?("msg") || val.starts_with?(@name)
          case val
          when .starts_with? /\d{13}-\d{1}/
            keys << val
          else
            values << (E).from_json(Base64.decode_string(val))  
          end
        else
          raise "Error parsing XREAD"
        end
      end 
      Hash.zip(keys, values)
    end

    private def broadcast(events : Hash(String, E), consumers : Set(C), last_message_id : String)
      events.each do |message_id, event|
        consumers.each { |c| c.on event }
        @from = message_id
      end
    end
  end
end
