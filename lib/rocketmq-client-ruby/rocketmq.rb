# frozen_string_literal: true

require 'ffi' unless defined?(FFI)

module Rocketmq
  # This module mainly defines the export method of librockmqclient
  module C
    def self.attach_function_maybe(*args)
      attach_function(*args)
    rescue FFI::NotFoundError
      puts("Missing function: #{args[0]} detail: #{args}")
    end

    extend FFI::Library
    ffi_lib %w[librocketmq]

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

    TransactionStatus = enum(
      :commit, 0,
      :rollback, 1,
      :unknown, 2
    )

    ConsumeStatus = enum(
      :consume_success, 0,
      :reconsume_later, 1
    )

    MessageProperty = enum(
      :trace_switch, 'TRACE_ON',
      :msg_region, 'MSG_REGION',
      :keys, 'KEYS',
      :tags, 'TAGS',
      :wait_store_msg_ok, 'WAIT',
      :delay_time_level, 'DELAY',
      :retry_topic, 'RETRY_TOPIC',
      :real_topic, 'REAL_TOPIC',
      :real_queue_id, 'REAL_QID',
      :transaction_prepared, 'TRAN_MSG',
      :producer_group, 'PGROUP',
      :min_offset, 'MIN_OFFSET',
      :max_offset, 'MAX_OFFSET',
      :buyer_id, 'BUYER_ID',
      :origin_message_id, 'ORIGIN_MESSAGE_ID',
      :transfer_flag, 'TRANSFER_FLAG',
      :correction_flag, 'CORRECTION_FLAG',
      :mq2_flag, 'MQ2_FLAG',
      :reconsume_tiem, 'RECONSUME_TIME',
      :uniq_client_message_id_keyidx, 'UNIQ_KEY',
      :max_reconsume_times, 'MAX_RECONSUME_TIMES',
      :consume_start_timestamp, 'CONSUME_START_TIME'
    )

    class SendResult < FFI::Struct
      layout :send_status, :int,
             :msg_id, :char, 256,
             :offset, :long_long
    end

    callback :msg_consume_callback, %i[pointer pointer], :int
    callback :transaction_check_callback, %i[pointer pointer pointer], :int
    callback :local_transaction_execute_callback, %i[pointer pointer pointer], :int

    # Message
    attach_function :CreateMessage, [:string], :pointer
    attach_function :DestroyMessage, [:pointer], Status
    attach_function :SetMessageKeys, %i[pointer string], Status
    attach_function :SetMessageTags, %i[pointer string], Status
    attach_function :SetMessageBody, %i[pointer string], Status
    attach_function :SetByteMessageBody, %i[pointer string int], Status
    attach_function :GetMessageProperty, %i[pointer string], :string
    attach_function :SetMessageProperty, %i[pointer string string], Status
    attach_function :SetDelayTimeLevel, %i[pointer int], Status

    # TransactionMQProducer
    attach_function :CreateTransactionProducer, %i[string transaction_check_callback pointer], :pointer
    attach_function :SendMessageTransaction, %i[pointer pointer local_transaction_execute_callback pointer pointer], :int
    # Producer
    attach_function :CreateProducer, [:string], :pointer
    attach_function :CreateOrderlyProducer, [:string], :pointer
    attach_function :SetProducerNameServerDomain, %i[pointer string], Status
    attach_function :SetProducerNameServerAddress, %i[pointer string], Status
    attach_function :SetProducerSendMsgTimeout, %i[pointer int], Status
    attach_function :SetProducerCompressLevel, %i[pointer int], Status
    attach_function :SetProducerMaxMessageSize, %i[pointer int], Status
    attach_function :SetProducerGroupName, %i[pointer string], Status
    attach_function :SetProducerInstanceName, %i[pointer string], Status
    attach_function :SetProducerSessionCredentials, %i[pointer string string string], Status
    attach_function :SendMessageSync, %i[pointer pointer pointer], Status
    attach_function :SendMessageOneway, %i[pointer pointer pointer], Status
    attach_function :SendMessageOrderlyByShardingKey, %i[pointer pointer string pointer], Status
    attach_function :StartProducer, [:pointer], Status
    attach_function :ShutdownProducer, [:pointer], Status

    # PushConsumer
    attach_function :CreatePushConsumer, [:string], :pointer
    attach_function :SetPushConsumerMessageModel, [:pointer, MessageModel], Status
    attach_function :StartPushConsumer, [:pointer], Status
    attach_function :ShutdownPushConsumer, [:pointer], Status
    attach_function :SetPushConsumerThreadCount, %i[pointer int], Status
    attach_function :SetPushConsumerMessageBatchMaxSize, %i[pointer int], Status
    attach_function :SetPushConsumerInstanceName, %i[pointer string], Status
    attach_function :SetPushConsumerNameServerAddress, %i[pointer string], Status
    attach_function :SetPushConsumerNameServerDomain, %i[pointer string], Status
    attach_function :GetPushConsumerGroupID, [:pointer], :string
    attach_function :SetPushConsumerGroupID, %i[pointer string], Status
    attach_function :SetPushConsumerSessionCredentials, %i[pointer string string string], Status
    attach_function :RegisterMessageCallback, %i[pointer msg_consume_callback], Status
    attach_function :RegisterMessageCallbackOrderly, %i[pointer msg_consume_callback], Status
    attach_function :UnregisterMessageCallback, [:pointer], Status
    attach_function :UnregisterMessageCallbackOrderly, [:pointer], Status
    attach_function :Subscribe, %i[pointer string string], Status

    # ReceivedMessage
    attach_function :GetMessageTopic, [:pointer], :string
    attach_function :GetMessageTags, [:pointer], :string
    attach_function :GetMessageKeys, [:pointer], :string
    attach_function :GetMessageBody, [:pointer], :string
    attach_function :GetMessageId, [:pointer], :string
    attach_function :GetMessageDelayTimeLevel, [:pointer], :int
    attach_function :GetMessageQueueId, [:pointer], :int
    attach_function :GetMessageReconsumeTimes, [:pointer], :int
    attach_function :GetMessageStoreSize, [:pointer], :int
    attach_function :GetMessageBornTimestamp, [:pointer], :long_long
    attach_function :GetMessageStoreTimestamp, [:pointer], :long_long
    attach_function :GetMessageQueueOffset, [:pointer], :long_long
    attach_function :GetMessageCommitLogOffset, [:pointer], :long_long
    attach_function :GetMessagePreparedTransactionOffset, [:pointer], :long_long
    attach_function :GetMessageProperty, %i[pointer string], :string
  end
end
