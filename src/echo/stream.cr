module Echo
  module Stream(E, C)
    abstract def subscribe(consumer : C)
    abstract def unsubscribe(consumer : C)
    abstract def publish(event : E)
  end
end

require "./streams/**"
