module Client
  class Producer
    include Rocketmq::C

    class SendResult
      def initialize(status, msg_id, offset)
        @status = status
        @msg_id = msg_id
        @offset = offset
      end
    end

    def initialize(group_id, orderly=false, timeout=nil, compass_level=nil, max_message_size=nil)
      @producer = CreateProducer(group_id)
      raise 'Returned null pointer when create Producer' unless @producer
    end

    def set_name_server_address(addr)
      SetProducerNameServerAddress(@producer, addr)
    end

    def send_sync(msg)
      c_result = CSendResult.new
      SendMessageSync(@producer, msg.raw, c_result.to_ptr)
      SendResult.new(c_result[:send_status], c_result[:msg_id], c_result[:offset])
    end

    def start
      StartProducer(@producer)
    end

    def shutdown
      ShutdownProducer(@producer)
    end
  end
end
