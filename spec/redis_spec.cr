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
    p "Count #{@count}"
  end
end

describe Echo do
  consumer = WorldConsumer.new
  consumer.last_message_id = "1602958178258-0"
  producer = WorldPublisher.new

  before_each do
    Echo::REDIS.command(["DEL", World.to_s])
  end

  it "subscribes a consumer for event" do
    producer.publish name: "1"
    producer.publish "2"
    producer.publish "3"

    spawn consumer.subscribe
    sleep 1.seconds
    consumer.count.should eq 3
  end
end
