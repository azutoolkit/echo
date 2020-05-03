require "./spec_helper"

class World
  include Echo::Event
  getter name = "World"
end

class Name
  include Echo::Event
  getter name = "John Carter"
end

class TestProducer
  include Echo::Producer(World | Name)
end

class TestConsumer
  include Echo::Consumer(World | Name)

  def on(event : World | Name)
    p "#{event.name}"
  end
end

class TestConsumer2
  include Echo::Consumer(Name | World)

  def on(event : World | Name)
    p "#{event.name}"
  end
end

describe Echo do
  producer = TestProducer.new

  it "subscribes a consumer for event" do
    producer.subscribe TestConsumer.new, TestConsumer2.new
    producer.consumers.size.should eq 2
  end

  it "subscribes a consumer for event" do
    producer.publish World.new, Name.new
  end
end
