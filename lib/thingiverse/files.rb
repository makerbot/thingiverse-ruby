module Thingiverse
  class Files
    include ActiveModel::Validations
    validates_presence_of :name

    attr_accessor :id, :name, :thumbnail, :url, :public_url, :threejs_url
    def initialize(attributes={})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    def attributes
      {
        :id => id,
        :name => name,
        :thumbnail => thumbnail,
        :url => url,
        :public_url => public_url,
        :threejs_url => threejs_url
      }
    end
  end
end
