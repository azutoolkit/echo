require "./spec_helper"

struct World
  include Echo::Event
  getter name : String = ""

  def initialize(@name)
  end
end

struct Marco
  include Echo::Event
  getter name = "Marco"
end

class MemWorldProducer
  include Echo::Producer::Memory(World)
  include Echo::Producer::Memory(Marco)
end

class MemWorldConsumer
  include Echo::Consumer(World)
  include Echo::Consumer(Marco)

  getter count : Int32 = 0

  def on(event : World | Marco)
    @count += 1
    p "id: #{event.event_id}, Name: #{event.name}, count: #{count}"
  end
end

describe Echo do
  world = MemWorldProducer.new
  consumer = MemWorldConsumer.new
  world.subscribe consumer
  event = World.new "John Doe"

  it "subscribes a consumer for event" do
    consumer.count.should eq 0
    world.publish event
    world.publish  World.new("Eva Lily")
    
    sleep 0.millisecond

    consumer.count.should eq 2
  end
end
