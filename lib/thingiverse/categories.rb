module Thingiverse
  class Categories
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
  end
end
