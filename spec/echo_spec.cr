require "./spec_helper"

struct HelloEvent
  include Echo::Event
  getter name = "John Carter!"
end

struct HelloWorld
  include Echo::Event
  getter name = "World"
end

class MyProducer
  include Echo::Producer(HelloEvent)
  include Echo::Producer(HelloEvent)

  def call
    event = HelloEvent.new
    world = HelloWorld.new
    publish(event2)
    publish(world)
  end
end

class MyConsumer
  include Echo::Consumer(HelloEvent)
  include Echo::Consumer(HelloWorld)
  
  def on(event : HelloEvent)
    p "Two"
    p "Hello, #{event.name}"
  end

  def on(event : HelloWorld)
    p "Two"
    p "Hello, #{event.name}"
  end
end

describe Echo do
  producer = MyProducer.new
  
  it "works" do
    event = HelloEvent.new
    world = HelloWorld.new

    producer.publish(event).should eq "Hello, John Carter!"
  end
end
