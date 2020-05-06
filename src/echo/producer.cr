module Echo
  module Producer(T)
    EVENTS =  [] of String
    macro included
      {% EVENTS << T.stringify %}
    end

    macro finished
    {% name = EVENTS.join("_").stringify.gsub(/::|\s\|\s|\)|\(/, "_").underscore %}
    {% consumers = EVENTS.map { |e| "Echo::Consumer(#{e.id})" }%}

    getter stream = Echo::Redis({{EVENTS.join(" | ").id}}, {{consumers.join(" | ").id}}).new(name: {{name.id}})
    
    forward_missing_to stream
    
    def subscribe(*consumers : {{consumers.join(" | ").id}})
      consumers.each do |c| 
        stream.subscribe c
      end
    end

    def publish(*events : {{EVENTS.join(" | ").id}})
      events.each { |e| stream.publish e }
    end
    end
  end
end