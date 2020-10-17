module Echo
  # The Stream is a new data type introduced with Redis 5.0, which models a log data 
  # structure in a more abstract way, however the essence of the log is still intact: 
  # like a log file, often implemented as a file open in append only mode, Redis 
  # streams are primarily an append only data structure. At least conceptually, because 
  # being Redis Streams an abstract data type represented in memory, they implement more 
  # powerful operations, to overcome the limits of the log file itself.
  #
  class Redis(Message)
    enum CMD
      XADD
      XREAD
      BLOCK
      STREAMS
    end

    ID = "*"
    TIMEOUT = "0"
    MESSAGE_KEY = "payload"
    ERROR_PARSING_XREAD = "Error parsing XREAD"
    REGUALR_EXP = /\d{13}-\d{1}/
    FROM = (Time.utc.to_unix_ms - 1).to_s

    def publish(message : Message)
      encoded = Base64.urlsafe_encode(message.to_json)
      send_msg encoded
    end
    
    def subscribe(consumer : Consumer)
      message = last_message(consumer)
      xread_parser(message).each do |message_id, event|
        consumer.last_message_id = message_id
        consumer.on event
      end
      subscribe consumer
    end

    private def send_msg(payload)
      cmd = [CMD::XADD.to_s, Message.to_s, ID, MESSAGE_KEY, payload]
      REDIS.string_command(cmd)
    end

    private def last_message(consumer)
      cmd = [CMD::XREAD.to_s, CMD::BLOCK.to_s, TIMEOUT, CMD::STREAMS.to_s, Message.to_s, consumer.last_message_id]
      REDIS.string_array_command(cmd).as(Array).first.as(Array)
    end

    private def xread_parser(payload, keys = Array(String).new, values = Array(Message).new)
      payload.each do |part|
        return xread_parser(part.as(Array), keys, values) if part.is_a? Array(::Redis::RedisValue)
        case val = part.to_s
        when .starts_with?(MESSAGE_KEY) then next
        when .starts_with?(Message.to_s) then next
        when .starts_with? REGUALR_EXP then keys << val
        else values << (Message).from_json(Base64.decode_string(val))  
        end
      end 
      Hash.zip(keys, values)
    end
  end
end