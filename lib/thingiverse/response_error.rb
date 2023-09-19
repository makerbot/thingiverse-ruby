module Thingiverse
  class ResponseError < StandardError
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
