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

class WorldProducer
  include Echo::Producer(World)
  include Echo::Producer(Marco)
end

class WorldConsumer
  include Echo::Consumer(World)
  include Echo::Consumer(Marco)

  getter count : Int32 = 0

  def on(event : World | Marco)
    @count += 1
    p "Name: #{event.name}, count: #{count}"
  end
end

describe Echo do
  world = WorldProducer.new
  consumer = WorldConsumer.new
  world.subscribe consumer
  event = World.new "John Doe"
  
  it "subscribes a consumer for event" do
    consumer.count.should eq 0
    world.publish event
    
    sleep 1.second # wait since specs runs faster
    consumer.count.should eq 1
  end
end
