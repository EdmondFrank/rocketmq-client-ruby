# frozen_string_literal: true

module Client
  # PushConsumer
  class PushConsumer
    include Rocketmq::C

    def initialize(group_id, orderly: false, message_model: MessageModel[:clustering])
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

    def set_name_server_domain(domain)
      SetPushConsumerNameServerDomain(@push_consumer, domain)
    end

    def set_session_credentials(access_key, access_secret, channel)
      SetPushConsumerSessionCredentials(@push_consumer, access_key, access_secret, channel)
    end

    def subscribe(topic, callback, expression: '*')
      on_message =
        FFI::Function.new(:int, %i[pointer pointer]) do |_, msg|
        exc = nil
        begin
          consume_result = callback.call(ReceivedMessage.new(msg))
          if consume_result != ConsumeStatus[:consume_success] &&
             consume_result != ConsumeStatus[:reconsume_later]
            raise StandardError.new('Consume status error, please use enum \'ConsumeStatus\' as response')
          end
          return consume_result
        rescue => ex
          exc = ex
          return ConsumeStatus[:reconsume_later]
        ensure
          raise exc if exc
        end
      end
      Subscribe(@push_consumer, topic, expression)
      register_callback(on_message)
    end

    def get_group
      GetPushConsumerGroupID(@push_consumer)
    end

    def set_group(group_id)
      SetPushConsumerGroupID(@push_consumer, group_id)
    end

    def set_thread_count(thread_count)
      SetPushConsumerThreadCount(@push_consumer, thread_count)
    end

    def set_message_batch_max_size(max_size)
      SetPushConsumerMessageBatchMaxSize(@push_consumer, max_size)
    end

    def set_instance_name(name)
      SetPushConsumerInstanceName(@push_consumer, name)
    end

    def start
      StartPushConsumer(@push_consumer)
    end

    def shutdown
      unregister_callback(@push_consumer) if @callback_refs.length.positive?
      ShutdownPushConsumer(@push_consumer)
    end

    private

    def register_callback(callback)
      register_func =
        if @orderly
          :RegisterMessageCallbackOrderly
        else
          :RegisterMessageCallback
        end
      @callback_refs << callback
      send(register_func, @push_consumer, callback)
    end

    def unregister_callback
      unregister_func =
        if @orderly
          :UnregisterMessageCallbackOrderly
        else
          :UnregisterMessageCallback
        end
      send(unregister_func, @push_consumer)
      @callback_refs = []
    end
  end
end
