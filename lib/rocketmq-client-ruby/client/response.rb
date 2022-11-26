# frozen_string_literal: true

module Client
  # Response module
  class Response
    attr_reader :status, :msg_id, :offset_msg_id
    def initialize(send_result)
      @status = send_result[:send_status]
      @msg_id = send_result[:msg_id]
      @offset_msg_id = send_result[:offset_msg_id]
      @raw_result = send_result
    end
  end
end
