module Echo 
  module Stream
    abstract def send(event : Event)
    abstract def read(event : Event)
    abstract def remove(event)
  end
end