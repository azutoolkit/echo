
module Echo
  class Memory(T) < Stream
    include Enumerable(Consumer(T))
    
    getter consumers = Set(Echo::Consumer(T)).new

    def subscribe(consumer : Consumer(T))
      @consumers << consumer
    end

    def publish(event : T)
      @consumers.each do |consumer|
        consumer.on event
      end
      event
    end

    def each
      @consumers.each { |consumer| yield consumer } 
    end
  end
end