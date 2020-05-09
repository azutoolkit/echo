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
  include Echo::Producer::Redis(World)
  include Echo::Producer::Redis(Marco)
end

class WorldConsumer
  include Echo::Consumer(World)
  include Echo::Consumer(Marco)

  getter count : Int32 = 0

  def on(event : World | Marco)
    @count += 1
    p "id: #{event.event_id}, Name: #{event.name}, count: #{count}"
  end
end


describe Echo do
  world = WorldProducer.new
  consumer = WorldConsumer.new
  world.subscribe consumer
  event = World.new "John Doe"

  before_each do
    MiniRedis.new.send("DEL", "world_marco")
    sleep 2.second
  end

  it "subscribes a consumer for event" do
    world.from="1589032117141"
    world.publish event
    world.publish World.new("Eva Lily")

    sleep 1.millisecond

    consumer.count.should eq 2
  end
end
