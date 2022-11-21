module Client
  class PushConsumer
    include Rocketmq::C

    def initialize(group_id, orderly=false, message_model=MessageModel[:clustering])
      @orderly = orderly
      @push_consumer = CreatePushConsumer(group_id)
      @callback_refs = []
      raise StandardError.new('Returned null pointer when create Producer') unless @push_consumer
      set_message_model(message_model)
    end

    def set_message_model(model)
      SetPushConsumerMessageModel(@push_consumer, model)
    end

    def set_name_server_address(addr)
      SetPushConsumerNameServerAddress(@push_consumer, addr)
    end

    def subscribe(topic, callback, expression='*')
      on_message =
        FFI::Function.new(:int, [:pointer, :pointer]) do |consumer, msg|

        consume_result = callback.call(ReceivedMessage.new(msg))
        if consume_result != ConsumeStatus[:consume_success] &&
           consume_result != ConsumeStatus[:reconsume_later]
          raise StandardError.new('Consume status error, please use enum \'ConsumeStatus\' as response')
        end
        return consume_result
      end
      Subscribe(@push_consumer, topic, expression)
      register_callback(on_message)
    end

    def start
      StartPushConsumer(@push_consumer)
    end

    def shutdown
      ShutdownPushConsumer(@push_consumer)
    end

    private

    def register_callback(callback)
      register_func =
        @orderly ?
          :RegisterMessageCallbackOrderly :
          :RegisterMessageCallback
      @callback_refs << callback
      send(register_func, @push_consumer, callback)
    end
  end
end
