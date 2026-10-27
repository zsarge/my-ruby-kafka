require "socket"
require_relative 'wire'

module Zafka
  class Server
    def self.run
      server = TCPServer.new(9092)

      loop do
        Thread.start(server.accept) do |client|
          Wire.write_response(client)
          client.close
        end
      end
    end
  end
end
