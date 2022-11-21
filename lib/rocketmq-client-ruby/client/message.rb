module Client
  class Message
    include Rocketmq::C

    def initialize(topic)
      @message = CreateMessage(topic)
    end

    def set_keys(keys)
      SetMessageKeys(@message, keys)
    end

    def set_tags(tags)
      SetMessageTags(@message, tags)
    end

    def set_body(body)
      SetMessageBody(@message, body)
    end

    def raw
      @message
    end
  end
end
