module Zafka
  module Wire
    # https://github.com/codecrafters-io/build-your-own-kafka/blob/main/stage_descriptions/base-02-nv3.md
    Message = Struct.new(:message_size, :header, :body) do
      # def self.write_response_header(client)
      # c
      # end

      # private

      # def self.this_method
      # 10.times do
      # puts 'test'
      # end
      # end
    end

    def self.write_response(client)
      write_response_header(client)
    end

    private

    INT_32_BE = "l>"

    def self.write_response_header(client)
      # https://github.com/codecrafters-io/build-your-own-kafka/blob/main/stage_descriptions/base-02-nv3.md#the-message_size-field
      size = client.read(4).unpack1("N")
      request_bytes = client.read(size)

      message_size = 0x00_00_00_00
      correlation_id = 0x00_00_00_07 # hardcoded

      header = [message_size, correlation_id].pack(INT_32_BE + "2")

      client.write(header)
    end
  end
end
