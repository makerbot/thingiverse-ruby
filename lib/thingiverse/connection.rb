module Thingiverse
  class Connection
    include HTTParty
    # debug_output $stderr
    attr_accessor :client_id, :client_secret, :code, :access_token, :auth_url, :base_url

    def initialize(client_id = nil, client_secret = nil, code = nil)
      @client_id      = client_id
      @client_secret  = client_secret
      @code           = code

      self.class.base_uri(self.base_url)

      self.get_token if @client_id and @client_secret and @code
    end

    def auth_url
      @auth_url || 'http://www.thingiverse.com/login/oauth/access_token'
    end

    def base_url=(url)
      @base_url = url
      self.class.base_uri(url)
    end

    def base_url
      @base_url || 'https://api.thingiverse.com'
    end

    def access_token=(token)
      @access_token = token
      self.class.headers "Authorization" => "Bearer #{@access_token}"
    end

    def get_token
      auth_response = self.class.post(auth_url, :query => {:client_id => @client_id, :client_secret => @client_secret, :code => @code})

      raise "#{auth_response.code}: #{auth_response.body.inspect}" unless auth_response.success?

      response = CGI::parse(auth_response.parsed_response)

      @access_token = response['access_token'].to_s

      self.class.headers "Authorization" => "Bearer #{@access_token}"

      @access_token
    end

    def things
      Thingiverse::Things
    end

    def users
      Thingiverse::Users
    end
  end
end
