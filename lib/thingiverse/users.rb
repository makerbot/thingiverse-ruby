module Thingiverse
  class Users
    include Thingiverse::DynamicAttributes

    def self.find(user_name)
      response = Thingiverse::Connection.get("/users/#{user_name}")
      raise ResponseError.new(response) unless response.success?
      self.new response.parsed_response
    end
  end
end
