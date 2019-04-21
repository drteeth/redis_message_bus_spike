require 'pp'

namespace :sledge_listener do

  desc "start the listener"
  task start: :environment do
    redis = Redis.new(host: ENV["REDIS_HOST"])

    loop do
      puts "listening..."

      # simple_read_from_bus
      resp = consumer_group_read(redis)
      next if resp.empty?

      messages = resp.fetch("pn_message_bus")
      messages.each do |id, message|
        payload = JSON.parse(message["payload"])
        pp message: Message.create!(payload)
      end
    end
  end

  private

  def simple_read_from_bus(redis)
    redis.xread("pn_message_bus", "$", block: 5000)
  end

  def consumer_group_read(redis)
    begin
     pp redis.xgroup(:create, "pn_message_bus", "super-derp", "$")
    rescue Redis::CommandError => e
      pp error: e
    end

    redis.xreadgroup("super-derp", "consumer1", "pn_message_bus", ">", block: 5000)
  end

end
