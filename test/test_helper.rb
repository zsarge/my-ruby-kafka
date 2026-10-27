require "minitest/autorun"
require "my_kafka"
require "rbconfig"
require "socket"
require "timeout"

class BrokerProcess
  PORT = 9092

  def start
    entrypoint = ENV.fetch("BROKER_ENTRYPOINT", "bin/server")

    @pid = Process.spawn(
      { "KAFKA_PORT" => PORT.to_s },
      RbConfig.ruby,
      entrypoint,
      out: File::NULL,
      err: File::NULL
    )
  end

  def wait_until_listening
    Timeout.timeout(2) do
      loop do
        TCPSocket.open("127.0.0.1", PORT, connect_timeout: 0.1).close
        return true
      rescue Errno::ECONNREFUSED, Errno::ENOENT
        sleep 0.02
      end
    end
  rescue Timeout::Error
    raise Minitest::Assertion,
          "broker did not listen on 127.0.0.1:#{PORT} within 2 seconds"
  end

  def stop
    return unless @pid

    Process.kill("TERM", @pid)
    Process.wait(@pid)
  rescue Errno::ESRCH, Errno::ECHILD
    nil
  end
end
