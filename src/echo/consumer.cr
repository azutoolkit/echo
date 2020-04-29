module Echo
  module Consumer(E)
    abstract def on(event : E)
  end
end