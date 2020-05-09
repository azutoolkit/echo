module Echo
  module Producer::Redis(T)
    REDIS_EVENTS = [] of String

    macro included
      {% REDIS_EVENTS << T.stringify %}
    end

    macro finished
      {% unless REDIS_EVENTS.empty? %}
      {% name = REDIS_EVENTS.sort.join("_").stringify.gsub(/::|\s\|\s|\)|\(/, "_").underscore %}
      {% consumers = REDIS_EVENTS.sort.map { |e| "Echo::Consumer(#{e.id})" } %}

      getter stream = Echo::Redis({{REDIS_EVENTS.sort.join(" | ").id}}, {{consumers.join(" | ").id}}).new(name: {{name.id}})
      
      forward_missing_to stream
      
      def subscribe(*consumers : {{consumers.join(" | ").id}})
        consumers.each do |c| 
          stream.subscribe c
        end
      end

      def publish(*events : {{REDIS_EVENTS.sort.join(" | ").id}})
        events.each { |e| stream.publish e }
      end
      {% end %}
    end
  end
end
