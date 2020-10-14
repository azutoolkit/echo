module Echo
  module Consumer(Message, Stream)
    property last_message_id = "$"

    macro included
      @stream = Stream(Message).new
    end

    def initialize
      spawn @stream.subscribe(self)
    end

    abstract def on(message : Message)
  end
end