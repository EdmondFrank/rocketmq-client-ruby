module Client
  class Producer
    include Rocketmq::C

    def initialize(group_id, orderly=false, timeout=nil, compass_level=nil, max_message_size=nil)
      @producer = CreateProducer(group_id)
      raise StandardError.new('Returned null pointer when create Producer') unless @producer
    end

    def set_name_server_address(addr)
      SetProducerNameServerAddress(@producer, addr)
    end

    def send_sync(msg)
      c_result = SendResult.new
      SendMessageSync(@producer, msg.raw, c_result.to_ptr)
      c_result
    end

    def start
      StartProducer(@producer)
    end

    def shutdown
      ShutdownProducer(@producer)
    end
  end
end
