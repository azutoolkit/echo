require "uuid"
require "json"

module Echo
  module Message
    macro included
      include JSON::Serializable

      getter _id : String = UUID.random.to_s
      getter _time : Time = Time.utc
    end
  end
end
