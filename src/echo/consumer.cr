module Echo
  module Consumer(T)
    abstract def on(event : T)
  end
end