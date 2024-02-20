module Thingiverse
  class Tags
    include Thingiverse::DynamicAttributes

    def self.find(tag_name)
      response = Thingiverse::Connection.get("/tags/#{tag_name}")
      raise ResponseError.from(response) unless response.success?
      self.new response.parsed_response
    end

    def things(query = {})
      Thingiverse::Pagination.new(Thingiverse::Connection.get(things_url, :query => query), Thingiverse::Things)
    end
  end
end
