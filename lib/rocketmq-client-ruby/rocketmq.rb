require "ffi" unless defined?(FFI)

module Rocketmq
  module C
    def self.attach_function_maybe(*args)
      attach_function(*args)
    rescue FFI::NotFoundError # rubocop:disable Lint/HandleExceptions
    end

    extend FFI::Library
    ffi_lib %w{librocketmq}

    class CSendResult < FFI::Struct
      layout :send_status, :int,
             :msg_id, :char, 256,
             :offset, :long_long
    end

    enum :status, [
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
         ]

    attach_function :CreateMessage, [:string], :pointer
    attach_function :DestroyMessage, [:pointer], :status
    attach_function :SetMessageKeys, [:pointer, :string], :status
    attach_function :SetMessageTags, [:pointer, :string], :status
    attach_function :SetMessageBody, [:pointer, :string], :status
    attach_function :SetByteMessageBody, [:pointer, :string, :int], :status
    attach_function :SetMessageProperty, [:pointer, :string, :string], :status
    attach_function :CreateProducer, [:string], :pointer
    attach_function :SetProducerNameServerAddress, [:pointer, :string], :status
    attach_function :SendMessageSync, [:pointer, :pointer, :pointer], :status
    attach_function :StartProducer, [:pointer], :status
    attach_function :ShutdownProducer, [:pointer], :status
  end
end
