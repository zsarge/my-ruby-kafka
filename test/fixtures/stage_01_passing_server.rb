require "socket"

port = Integer(ENV.fetch("KAFKA_PORT", "9092"))
server = TCPServer.new("127.0.0.1", port)

loop do
  server.accept.close
end
