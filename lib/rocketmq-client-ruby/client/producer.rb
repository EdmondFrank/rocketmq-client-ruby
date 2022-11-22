module Client
  class Producer
    include Rocketmq::C

    def initialize(group_id, orderly=false, timeout=nil, compass_level=nil, max_message_size=nil)
      producer_factory =
        orderly ?
          :CreateOrderlyProducer :
          :CreateProducer

      @producer = send(producer_factory, group_id)
      @callback_refs = []
      raise StandardError.new('Returned null pointer when create Producer') unless @producer

      set_timeout(timeout) if timeout.to_i > 0
      set_compress_level(compass_level) if compass_level
      set_max_message_size(max_message_size) if max_message_size.to_i > 0
    end

    def set_compress_level(compass_level)
      SetProducerCompressLevel(@producer, compass_level)
    end

    def set_max_message_size(max_message_size)
      SetProducerMaxMessageSize(@producer, max_message_size)
    end

    def set_timeout(timeout)
      SetProducerSendMsgTimeout(@producer, timeout)
    end

    def set_name_server_domain(domain)
      SetProducerNameServerDomain(@producer, domain)
    end

    def set_name_server_address(addr)
      SetProducerNameServerAddress(@producer, addr)
    end

    def set_session_credentials(access_key, access_secret, channel)
      SetProducerSessionCredentials(@producer, access_key, access_secret, channel)
    end

    def send_sync(msg)
      c_result = SendResult.new
      SendMessageSync(@producer, msg.raw, c_result.to_ptr)
      c_result
    end

    def send_oneway(msg)
      SendMessageOneway(msg)
    end

    def send_orderly_with_sharding_key(msg, sharding_key)
      c_result = SendResult.new
      SendMessageOrderlyByShardingKey(@producer, msg.raw, sharding_key, c_result.to_ptr)
      c_result
    end

    def set_group(group_name)
      SetProducerGroupName(@producer, group_name)
    end

    def set_instance_name(instance_name)
      SetProducerInstanceName(@producer, instance_name)
    end

    def start
      StartProducer(@producer)
    end

    def shutdown
      ShutdownProducer(@producer)
    end
  end
end
