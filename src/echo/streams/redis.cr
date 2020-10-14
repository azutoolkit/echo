require "mini_redis"

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
    @redis = MiniRedis.new

    def publish(message : Message)
      send_msg Base64.urlsafe_encode(message.to_json)
    end
    
    def subscribe(consumer : Consumer)
      message = last_message(consumer)
      xread_parser(message).each do |message_id, event|
        consumer.last_message_id = message_id
        consumer.on event
      end
      p consumer.count
      subscribe consumer
    end

    private def send_msg(payload)
      @redis.send(CMD::XADD.to_s, Message.to_s, ID, MESSAGE_KEY, payload)
    end

    private def last_message(consumer)
      @redis.send(
        CMD::XREAD.to_s, 
        CMD::BLOCK.to_s, TIMEOUT, 
        CMD::STREAMS.to_s, Message.to_s, consumer.last_message_id )
        .raw.as(Array).first.raw.as(Array)
    end

    private def xread_parser(payload, keys = Array(String).new, values = Array(Message).new)
      payload.each do |stream|
        case raw = stream.raw
        when Array(MiniRedis::Value) 
          xread_parser(raw, keys, values)
        when Bytes 
          val = String.new(raw)
          next if val.starts_with?(MESSAGE_KEY) || val.starts_with?(Message.to_s)
          case val
          when .starts_with? REGUALR_EXP
            keys << val
          else
            values << (Message).from_json(Base64.decode_string(val))  
          end
        else
          raise ERROR_PARSING_XREAD
        end
      end 
      Hash.zip(keys, values)
    end
  end
end