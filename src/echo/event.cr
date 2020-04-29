module Echo
  module Event
    getter event_id = UUID.random
    getter event_time = Time.utc
  end
end