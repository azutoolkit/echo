module Echo
  # A Producer application creates and sends messages to a `Stream`. 
  # `Consumer`  applications create a subscription to a event to receive 
  # messages from it. Communication can be one-to-many (fan-out), many-to-one 
  # (fan-in), and many-to-many.
  module Producer(Message, Stream)
    macro included
      @stream = Stream(Message).new
    end

    # Publishes a message of type `M`
    def publish(message : Message)
      @stream.publish message
    end

    # Publishes a message of type `M` constructed from named tuple arguments
    def publish(**args)
      @stream.publish Message.new(**args)
    end
    
    # Publishes a message of type `M` constructed from a tuple arguments
    def publish(*args)
      @stream.publish Message.new(*args)
    end
  end
end