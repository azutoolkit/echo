module Echo
  module Producer(T)
    macro included
      def publish(event : T)
        Echo.streams[T.to_s].publish(event)
      end
    end
  end
end