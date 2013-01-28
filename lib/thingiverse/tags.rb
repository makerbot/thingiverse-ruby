module Thingiverse
  class Tags
    include ActiveModel::Validations
    validates_presence_of :name

    attr_accessor :name, :url, :count
    def initialize(attributes={})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    def attributes
      {
        :name => name,
        :url => url,
        :count => count
      }
    end
  end
end
