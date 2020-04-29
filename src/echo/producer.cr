module Echo
  class Producer
    @name : Symbol

    def self.[](name : Symbol)
      new(name)
    end

    def initialize(@name)
    end

    def register(event : Event) 
      events[event.class]
    end

    def subscribe(consumer : Consumer)
      consumers << consumer
    end

    def publish(event, **payload)
    end
  end
end