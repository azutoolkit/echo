require "uuid"
require "msgpack"
require "json"
require "suzuri/json_serializable"

module Echo
  module Event 
    macro included
      include JSON::Serializable
    
      @event_id : String = UUID.random.to_s
      @event_time : Time = Time.utc

      def initialize
      end
    end
  end
end