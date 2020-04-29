
module Echo
  class Memory(T) < Stream
    def initialize
      @channel = Channel(T).new
      Echo.streams[T.to_s]=self
    end

    def subscribe(&block : T -> _)
      p T.to_s
    end

    def publish(event : T)
      @channel.send event
      event
    end
  end
end