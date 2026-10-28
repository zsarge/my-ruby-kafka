require 'stringio'

module Zafka
  module Wire
    # https://github.com/codecrafters-io/build-your-own-kafka/blob/main/stage_descriptions/base-02-nv3.md
    Message = Struct.new(:message_size, :header, :body)

    RequestHeader = Struct.new(
      *%i[request_api_key   
      request_api_version   
      correlation_id  
      client_id   
      TAG_BUFFER]
     )

    def self.write_response(client)
      data = read_full_message(client)
      p [:data, data]
      header = read_request_header(StringIO.new(data))
      p [:header, header]
      write_response_header(client, header)
    end

    private

    def self.read_full_message(client)
      size = client.read(4).unpack1("N")
      client.read(size)
    end

    def self.write_response_header(client, header)
      # https://github.com/codecrafters-io/build-your-own-kafka/blob/main/stage_descriptions/base-02-nv3.md#the-message_size-field

      message_size = 0x00_00_00_00
      # correlation_id = 0x00_00_00_07 # hardcoded
      correlation_id = header.correlation_id

      header = [message_size, correlation_id].pack("l>2")

      client.write(header)
    end

    def self.read_request_header(client)
      # https://docs.ruby-lang.org/en/3.4/packed_data_rdoc.html
      request_api_key = client.read(2).unpack1('s>')
      request_api_version = client.read(2).unpack1('s>')
      correlation_id = client.read(4).unpack1('l>')
      # client_id = ...
      # TAG_BUFFER = ...
      RequestHeader.new(request_api_key, request_api_version, correlation_id)
    end
  end
end
