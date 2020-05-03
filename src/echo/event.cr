require "uuid"

module Echo
  module Event 
    getter event_id : UUID = UUID.random
    getter event_time : Time = Time.utc
  end
end