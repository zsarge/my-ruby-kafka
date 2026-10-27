#!/usr/bin/env ruby

require 'socket'

server = TCPServer.new(9092)

loop do
  Thread.start(server.accept) do |client|
    client.puts "one day, this will be kafka..."
    client.close
  end
end

