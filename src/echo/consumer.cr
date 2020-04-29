module Echo
  module Consumer(T)
    abstract def on(event : T)
    
    macro included
      consumer = self.new
      Echo.streams[T.to_s].subscribe do |event| consumer.on(event.as(T)) end
    end
  end
end