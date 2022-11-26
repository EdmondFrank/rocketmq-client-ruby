# frozen_string_literal: true

module Client
  # Producer module
  class Producer
    include Rocketmq::C

    def initialize(group_id, orderly: false, timeout: nil, compress_level: nil, max_message_size: nil)
      producer_factory =
        if orderly
          :CreateOrderlyProducer
        else
          :CreateProducer
        end

      @producer = send(producer_factory, group_id)
      @callback_refs = []
      raise StandardError.new('Returned null pointer when create Producer') unless @producer

      set_timeout(timeout) if timeout.to_i.positive?
      set_compress_level(compress_level) if compress_level
      set_max_message_size(max_message_size) if max_message_size.to_i.positive?
    end

    def set_compress_level(compress_level)
      SetProducerCompressLevel(@producer, compress_level)
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
      Response.new(c_result)
    end

    def send_oneway(msg)
      SendMessageOneway(msg)
    end

    def send_orderly_with_sharding_key(msg, sharding_key)
      c_result = SendResult.new
      SendMessageOrderlyByShardingKey(@producer, msg.raw, sharding_key, c_result.to_ptr)
      Response.new(c_result)
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

    def destroy
      DestroyPushConsumer(@producer)
    end
  end
end
