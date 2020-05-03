module Echo
  module Producer(T)
    macro included
      {% name = T.stringify.gsub(/::|\s\|\s|\)|\(/, "_").underscore %}
      getter stream = Echo::Memory({{T}}).new
    end
    
    forward_missing_to stream

    def subscribe(*consumers : Consumer(T))
      consumers.each { |c| stream.subscribe c }
    end

    def publish(*events : T)
      events.each { |e| stream.publish e }
    end
  end
end