module Client
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
  end
end
