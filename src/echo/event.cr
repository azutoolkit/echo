require "uuid"
require "msgpack"
require "json"
require "suzuri/json_serializable"

module Echo
  module Event
    macro included
      include JSON::Serializable
    
      getter event_id : String = UUID.random.to_s
      getter event_time : Time = Time.utc
    end
  end
end
