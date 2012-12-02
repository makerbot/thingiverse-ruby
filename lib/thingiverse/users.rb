module Thingiverse
  class Users
    include ActiveModel::Validations
    validates_presence_of :name

    attr_accessor :id, :name, :thumbnail, :url, :public_url, :bio, :location, :registered, :last_active
    attr_accessor :email, :default_license
    attr_accessor :things_url, :copies_url, :likes_url
    
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
        :bio => bio,
        :location => location,
        :registered => registered,
        :last_active => last_active,
        :things_url => things_url,
        :copies_url => copies_url,
        :likes_url => likes_url,
        :email => email,
        :default_license => default_license
      }
    end
    
    def self.find(user_name)
      response = Thingiverse::Connection.get("/users/#{user_name}")
      raise "#{response.code}: TODO: Error Handling :)" unless response.success?
      self.new response.parsed_response
    end
  end
end
