module Thingiverse
  class ResponseError < StandardError
    def self.from(response)
      case response.code.to_i
      when 420, 429
        RateLimitExceededError.new(response)
      else
        new(response)
      end
    end

    def initialize(response)
      @response = response
    end

    attr_reader :response

    def message
      "#{response.code}: #{message_body} #{response.headers['x-error']}".strip
    end

    def message_body
      JSON.parse(response.body)['error']
    rescue
      response.body
    end
  end
end
