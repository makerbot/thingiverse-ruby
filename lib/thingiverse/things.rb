module Thingiverse
  class Things
    include ActiveModel::Validations
    validates_presence_of :name

    attr_accessor :id, :name, :thumbnail, :url, :public_url, :creator, :added, :modified, :is_published, :is_wip
    attr_accessor :ratings_enabled, :like_count, :description, :instructions, :license
    attr_accessor :files_url, :images_url, :likes_url, :ancestors_url, :derivatives_url, :tags_url, :categories_url
    
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
        :creator => creator, 
        :added => added, 
        :modified => modified,
        :is_published => is_published, 
        :is_wip => is_wip,
        :ratings_enabled => ratings_enabled, 
        :like_count => like_count, 
        :description => description, 
        :instructions => instructions, 
        :license => license, 
        :files_url => files_url, 
        :images_url => images_url, 
        :likes_url => likes_url,
        :ancestors_url => ancestors_url, 
        :derivatives_url => derivatives_url, 
        :tags_url => tags_url, 
        :categories_url => categories_url
      }
    end

    def files
      response = Thingiverse::Connection.get(files_url)
      raise "#{response.code}: TODO: Error Handling :)" unless response.success?
      response.parsed_response.collect do |attrs|
        Thingiverse::Files.new attrs
      end
    end

    # TODO: implement  :)
    # def self.create(attributes)
    #   thing = new(attributes)
    #   return thing unless thing.valid?
    # 
    #   response = post('/things', :body => thing.attributes)
    #   raise "#{response.code}: TODO: Error Handling :)" unless response.success?
    #   self.new(response.parsed_response)
    # end
    
    def self.find(thing_id)
      response = Thingiverse::Connection.get("/things/#{thing_id}")
      raise "#{response.code}: TODO: Error Handling :)" unless response.success?
      self.new response.parsed_response
    end
    
    def self.newest
      response = Thingiverse::Connection.get('/newest')
      raise "#{response.code}: TODO: Error Handling :)" unless response.success?
      response.parsed_response.collect do |attrs|
        self.new attrs
      end
    end
  end
end
