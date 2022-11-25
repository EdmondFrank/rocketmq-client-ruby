# frozen_string_literal: true

module Client
  # ReceivedMessage Module
  class ReceivedMessage
    include Rocketmq::C

    def initialize(handle)
      @handle = handle
    end

    def topic
      GetMessageTopic(@handle)
    end

    def tags
      GetMessageTags(@handle)
    end

    def keys
      GetMessageKeys(@handle)
    end

    def body
      GetMessageBody(@handle)
    end

    def id
      GetMessageId(@handle)
    end

    def delay_time_level
      GetMessageDelayTimeLevel(@handle)
    end

    def queue_id
      GetMessageQueueId(@handle)
    end

    def reconsume_times
      GetMessageReconsumeTimes(@handle)
    end

    def store_size
      GetMessageStoreSize(@handle)
    end

    def born_timestamp
      GetMessageBornTimestamp(@handle)
    end

    def store_timestamp
      GetMessageStoreTimestamp(@handle)
    end

    def queue_offset
      GetMessageQueueOffset(@handle)
    end

    def commit_log_offset
      GetMessageCommitLogOffset(@handle)
    end

    def prepared_transaction_offset
      GetMessagePreparedTransactionOffset(@handle)
    end

    def get_property(prop)
      GetMessageProperty(@handle, prop)
    end

    def [](key)
      get_property(key)
    end

    def to_s
      body
    end

    def inspect
      "<ReceivedMessage topic=#{topic} id=#{id} body=#{body}>"
    end
  end
end
