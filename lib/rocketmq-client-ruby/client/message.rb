# frozen_string_literal: true

module Client
  # Message module
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

    def set_property(key, value)
      SetMessageProperty(@message, key, value)
    end

    def get_property(key)
      GetMessageProperty(@message, key)
    end

    def set_delay_time_level(delay_time_level)
      SetDelayTimeLevel(@message, delay_time_level)
    end

    def [](key)
      get_property(key)
    end

    def []=(key, value)
      set_property(key, value)
    end

    def raw
      @message
    end
  end
end
