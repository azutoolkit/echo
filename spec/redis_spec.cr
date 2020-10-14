require "./spec_helper"

struct World
  include Echo::Message
  def initialize(@name : String)
  end
end

struct WorldPublisher
  include Echo::Producer(World, Echo::Redis)
end

# Class will maintain state
# Struct will loose state
class WorldConsumer
  include Echo::Consumer(World, Echo::Redis)
  getter count : Int32 = 0

  def on(message : World)
    @count += 1
  end
end

describe Echo do
  consumer = WorldConsumer.new
  producer = WorldPublisher.new

  before_each do
    MiniRedis.new.send("DEL", "world")
  end

  it "subscribes a consumer for event" do
    producer.publish name: "1"
    producer.publish "2"
    producer.publish "3"

    sleep 1

    consumer.count.should eq 3
  end
end
