module Thingiverse
  class Users
    include ActiveModel::Validations
    validates_presence_of :name

    attr_accessor :id, :name, :full_name, :thumbnail, :url, :public_url, :bio, :location, :registered, :last_active
    attr_accessor :email, :default_license, :is_following
    attr_accessor :things_url, :copies_url, :likes_url, :downloads_url, :collections_url

    def initialize(attributes={})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    def attributes
      {
        :id => id,
        :name => name,
        :full_name => full_name,
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
        :default_license => default_license,
        :downloads_url => downloads_url,
        :collections_url => collections_url,
        :is_following => is_following
      }
    end

    def self.find(user_name)
      response = Thingiverse::Connection.get("/users/#{user_name}")
      raise "#{response.code}: #{JSON.parse(response.body)['error']}" unless response.success?
      self.new response.parsed_response
    end
  end
end
