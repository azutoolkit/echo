module Echo
  module Producer::Memory(T)
    MEM_EVENTS = [] of String

    macro included
      {% MEM_EVENTS << T.stringify %}
    end

    macro finished
      {% unless MEM_EVENTS.empty? %}
      {% name = MEM_EVENTS.sort.join("_").stringify.gsub(/::|\s\|\s|\)|\(/, "_").underscore %}
      {% consumers = MEM_EVENTS.map { |e| "Echo::Consumer(#{e.id})" } %}

      getter stream = Echo::Memory({{MEM_EVENTS.sort.join(" | ").id}}, {{consumers.join(" | ").id}}).new(name: {{name.id}})
      
      forward_missing_to stream
      
      def subscribe(*consumers : {{consumers.join(" | ").id}})
        consumers.each do |c| 
          stream.subscribe c
        end
      end

      def publish(*events : {{MEM_EVENTS.sort.join(" | ").id}})
        events.each { |e| stream.publish e }
      end
      {% end %}
    end
  end
end
