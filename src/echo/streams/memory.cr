module Echo
  class Memory(Message)
    @channel = Channel(Message).new
    @subscribers = Set(Consumer).new

    def publish(message : Message)
      @channel.send message
    end

    def subscribe(consumer : Consumer)
      @subscribers << consumer
      loop do 
        message = @channel.receive
        @subscribers.each { |c| c.on message }
      end
    end
  end
end 