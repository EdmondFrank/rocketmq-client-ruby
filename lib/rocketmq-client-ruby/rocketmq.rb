require "ffi" unless defined?(FFI)

module Rocketmq
  module C
    def self.attach_function_maybe(*args)
      attach_function(*args)
    rescue FFI::NotFoundError # rubocop:disable Lint/HandleExceptions
    end

    extend FFI::Library
    ffi_lib %w{librocketmq}

    Status = enum(
      :ok, 0,
      :null_pointer, 1,
      :malloc_failed, 2,
      # producer
      :producer_start_failed, 10,
      :producer_send_sync_failed, 11,
      :producer_send_oneway_failed, 12,
      :producer_send_orderly_failed, 13,
      :producer_send_async_failed, 14,
      # push consumer
      :push_consumer_start_failed, 20,
      :not_support_now, -1
    )

    MessageModel = enum(
      :broadcasting, 0,
      :clustering, 1
    )

    ConsumeStatus = enum(
      :consume_success, 0,
      :reconsume_later, 1
    )

    class SendResult < FFI::Struct
      layout :send_status, :int,
             :msg_id, :char, 256,
             :offset, :long_long
    end

    callback :msg_consume_callback, [:pointer, :pointer], :int

    attach_function :CreateMessage, [:string], :pointer
    attach_function :DestroyMessage, [:pointer], Status
    attach_function :SetMessageKeys, [:pointer, :string], Status
    attach_function :SetMessageTags, [:pointer, :string], Status
    attach_function :SetMessageBody, [:pointer, :string], Status
    attach_function :SetByteMessageBody, [:pointer, :string, :int], Status
    attach_function :SetMessageProperty, [:pointer, :string, :string], Status
    attach_function :CreateProducer, [:string], :pointer
    attach_function :CreateOrderlyProducer, [:string], :pointer
    attach_function :SetProducerNameServerDomain, [:pointer, :string], Status
    attach_function :SetProducerNameServerAddress, [:pointer, :string], Status
    attach_function :SetProducerSendMsgTimeout, [:pointer, :int], Status
    attach_function :SetProducerCompressLevel, [:pointer, :int], Status
    attach_function :SetProducerMaxMessageSize, [:pointer, :int], Status
    attach_function :SetProducerGroupName, [:pointer, :string], Status
    attach_function :SetProducerInstanceName, [:pointer, :string], Status
    attach_function :SetProducerSessionCredentials, [:pointer, :string, :string, :string], Status
    attach_function :SendMessageSync, [:pointer, :pointer, :pointer], Status
    attach_function :SendMessageOneway, [:pointer, :pointer, :pointer], Status
    attach_function :SendMessageOrderlyByShardingKey, [:pointer, :pointer, :string, :pointer], Status
    attach_function :StartProducer, [:pointer], Status
    attach_function :ShutdownProducer, [:pointer], Status
    attach_function :CreatePushConsumer, [:string], :pointer
    attach_function :SetPushConsumerMessageModel, [:pointer, MessageModel], Status
    attach_function :StartPushConsumer, [:pointer], Status
    attach_function :ShutdownPushConsumer, [:pointer], Status
    attach_function :SetPushConsumerNameServerAddress, [:pointer, :string], Status
    attach_function :RegisterMessageCallback, [:pointer, :msg_consume_callback], Status
    attach_function :RegisterMessageCallbackOrderly, [:pointer, :msg_consume_callback], Status
    attach_function :GetMessageTopic, [:pointer], :string
    attach_function :GetMessageTags, [:pointer], :string
    attach_function :GetMessageKeys, [:pointer], :string
    attach_function :GetMessageBody, [:pointer], :string
    attach_function :GetMessageId, [:pointer], :string
    attach_function :Subscribe, [:pointer, :string, :string], Status
  end
end
