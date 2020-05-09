module Echo
  module Consumer(T)

    # When included subscribe to stream
    
    abstract def on(event : T)
  end
end
