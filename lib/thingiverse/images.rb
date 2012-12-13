module Thingiverse
  class Images
    include ActiveModel::Validations
    validates_presence_of :name

    attr_accessor :id, :name, :url, :sizes
    def initialize(attributes={})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end
    
    def attributes
      {
        :id => id,
        :name => name,
        :url => url,
        :sizes => sizes
      }
    end
  end
end
