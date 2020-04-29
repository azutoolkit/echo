require "./echo/event"
require "./echo/consumer"
require "./echo/producer"
require "./echo/stream"


module Echo
  VERSION = "0.1.0"
  STREAMS = Hash(String, Stream).new

  def self.streams
    STREAMS
  end
end
