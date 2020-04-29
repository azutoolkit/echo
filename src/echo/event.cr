require "uuid"

module Echo
  module Event 
    getter event_id : UUID = UUID.random
    getter event_time : Time = Time.utc

    macro included
      Echo::Memory({{@type.name.id}}).new
    end
  end
end