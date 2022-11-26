# frozen_string_literal: true

module Client
  # TransactionMQProducer module
  class TransactionMQProducer < Producer
    include Rocketmq::C
    def initialize(group_id, checker_callback, user_args: nil, timeout: nil, compress_level: nil, max_message_size: nil)
      # super(group_id, timeout, compress_level, max_message_size)
      @callback_refs = []

      on_check =
        FFI::Function.new(:int, %i[pointer pointer pointer]) do |_, msg_ptr, _|
        exc = nil
        begin
          msg = ReceivedMessage.new(msg_ptr)
          check_result = checker_callback.call(msg)
          if check_result != TransactionStatus[:unknown] &&
             check_result != TransactionStatus[:commit] &&
             check_result != TransactionStatus[:rollback]
            raise StandardError.new('Check transaction status error, please use enum \'TransactionStatus\' as response')
          end
          return check_result
        rescue => ex
          exc = ex
          return TransactionStatus[:unknown]
        ensure
          raise exc if exc
        end
      end

      @callback_refs << on_check
      @producer = CreateTransactionProducer(group_id, on_check, user_args)
      raise StandardError.new('Returned null pointer when create transaction producer') unless @producer

      set_timeout(timeout) if timeout.to_i.positive?
      set_compress_level(compress_level) if compress_level
      set_max_message_size(max_message_size) if max_message_size.to_i.positive?
    end

    def set_name_server_address(addr)
      SetProducerNameServerAddress(@producer, addr)
    end

    def send_message_in_transaction(message, local_execute, user_args: nil)

      on_local_exec =
        FFI::Function.new(:int, %i[pointer pointer pointer]) do |_, msg_ptr, user_args|
        exc = nil
        begin
          msg = ReceivedMessage.new(msg_ptr)
          execute_result = local_execute.call(msg)
          if execute_result != TransactionStatus[:unknown] &&
             execute_result != TransactionStatus[:commit] &&
             execute_result != TransactionStatus[:rollback]
            raise StandardError.new('Local transaction status error, please use enum \'TransactionStatus\' as response')
          end
          return execute_result
        rescue => ex
          exc = ex
          return TransactionStatus[:unknown]
        ensure
          raise exc if exc
        end
      end
      @callback_refs << on_local_exec
      c_result = SendResult.new
      begin
        SendMessageTransaction(@producer, message.raw, on_local_exec, user_args, c_result.to_ptr)
      ensure
        @callback_refs.delete(on_local_exec)
      end
      Reponse.new(c_result)
    end
  end
end
