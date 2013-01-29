module Thingiverse
  class Tags
    include ActiveModel::Validations
    validates_presence_of :name

    attr_accessor :name, :url, :count, :things_url
    def initialize(attributes={})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    def attributes
      {
        :name => name,
        :url => url,
        :count => count,
        :things_url => things_url
      }
    end
    
    def self.find(tag_name)
      response = Thingiverse::Connection.get("/tags/#{tag_name}")
      raise "#{response.code}: #{JSON.parse(response.body)['error']}" unless response.success?
      self.new response.parsed_response
    end
    
    def things(query = {})
      Thingiverse::Pagination.new(Thingiverse::Connection.get(things_url, :query => query), Thingiverse::Things)
    end
  end
end
