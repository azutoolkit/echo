module Echo
  class Memory(E, C)
    include Stream(E, C)
    getter consumers = Set(C).new

    @channel = Channel(E).new

    def initialize(@name : String)
    end

    def subscribe(consumer : C)
      @consumers << consumer
    end

    def publish(event : E)
      spawn consume(event, @consumers)
      event
    end

    def unsubscribe(consumer : C)
      consumers.delete consumer
    end

    private def consume(event : E, consumers : Set(C))
      consumers.each { |c| c.on event }
    end
  end
end
