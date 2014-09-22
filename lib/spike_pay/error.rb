class SpikePay
  class ApiError < StandardError
  end

  class InvalidRequestError < ApiError
    attr_reader :bad_value

    def initialize(message, bad_value)
      super(message)
      @bad_value = bad_value
    end
  end

  class InvalidResponseError < ApiError
  end

  class ApiConnectionError < ApiError
    attr_reader :cause

    def self.in_request(cause)
      self.new("API request failed with #{cause}", cause)
    end

    def self.invalid_json(cause)
      self.new("Server responded invalid JSON string", cause)
    end

    def initialize(message, cause)
      @cause = cause
      super(message)
    end
  end

  module ErrorResponse
    class InvalidRequestError < SpikePay::ApiError
      attr_reader :status, :data
      def initialize(status, raw_data)
        @status = status
        @data = SpikePay::ErrorData.new(raw_data || {})
        super(sprintf('%s: %s', 'InvalidRequestError', data.error.message))
      end
    end
    class AuthenticationError < SpikePay::ApiError
      attr_reader :status, :data
      def initialize(status, raw_data)
        @status = status
        @data = SpikePay::ErrorData.new(raw_data)
        super(sprintf('%s: %s', 'AuthenticationError', data.error.message))
      end
    end
    class CardError < SpikePay::ApiError
      attr_reader :status, :data
      def initialize(status, raw_data)
        @status = status
        @data = SpikePay::ErrorData.new(raw_data)
        super(sprintf('%s: %s', 'CardError', data.error.message))
      end
    end
    class ApiError < SpikePay::ApiError
      attr_reader :status, :data
      def initialize(status, raw_data)
        @status = status
        @data = SpikePay::ErrorData.new(raw_data)
        super(sprintf('%s: %s', 'ApiError', data.error.message))
      end
    end
  end
end
