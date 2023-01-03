module Thingiverse
  class Things
    include Thingiverse::DynamicAttributes

    def user
      response = Thingiverse::Connection.get("/users/#{creator['name']}")
      raise ResponseError.new(response) unless response.success?
      Thingiverse::Users.new response.parsed_response
    end

    def files(query = {})
      Thingiverse::Pagination.new(Thingiverse::Connection.get(@files_url, :query => query), Thingiverse::Files)
    end

    def images(query = {})
      Thingiverse::Pagination.new(Thingiverse::Connection.get(@images_url, :query => query), Thingiverse::Images)
    end

    def categories(query = {})
      Thingiverse::Pagination.new(Thingiverse::Connection.get(@categories_url, :query => query), Thingiverse::Categories)
    end

    def ancestors(query = {})
      Thingiverse::Pagination.new(Thingiverse::Connection.get(@ancestors_url, :query => query), Thingiverse::Things)
    end

    def tags
      response = Thingiverse::Connection.get(tags_url)
      raise ResponseError.new(response) unless response.success?
      response.parsed_response.collect do |attrs|
        Thingiverse::Tags.new attrs
      end
    end

    def save
      if @id.to_s == ""
        thing = Thingiverse::Things.create(@attributes)
      else
        response = Thingiverse::Connection.patch("/things/#{id}", :body => @attributes.to_json)
        raise ResponseError.new(response) unless response.success?

        thing = Thingiverse::Things.new(response.parsed_response)
      end

      thing.attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    # file_or_string can be a File or a String.
    # thingiverse_filename is optional if using a File (the File filename will be used by default) but is required if using a String
    def upload(file_or_string, thingiverse_filename=nil)
      # to support different File type objects (like Tempfile) lets look for .path
      if file_or_string.respond_to?("path")
        thingiverse_filename = File.basename(file_or_string.path) if thingiverse_filename.to_s == ""
        file_data = File.read(file_or_string.path)
      elsif file_or_string.is_a?(String)
        file_data = file_or_string
      else
        raise ArgumentError, "file_or_string not of accepted type. Expected File or String. Actual: #{file_or_string.class}"
      end

      raise ArgumentError, "Unable to determine filename" if thingiverse_filename.to_s == ""

      response = Thingiverse::Connection.post("/things/#{id}/files", :body => {:filename => thingiverse_filename}.to_json)
      raise ResponseError.new(response) unless response.success?

      parsed_response = JSON.parse(response.body)
      action = parsed_response["action"]
      query = parsed_response["fields"]

      # stupid S3 requires params to be in a certain order... so can't use HTTParty :(
      # prepare post data
      post_data = []
      # TODO: is query['bucket'] needed here?
      post_data << Curl::PostField.content('key',                     query['key'])
      post_data << Curl::PostField.content('AWSAccessKeyId',          query['AWSAccessKeyId'])
      post_data << Curl::PostField.content('acl',                     query['acl'])
      post_data << Curl::PostField.content('success_action_redirect', query['success_action_redirect'])
      post_data << Curl::PostField.content('policy',                  query['policy'])
      post_data << Curl::PostField.content('signature',               query['signature'])
      post_data << Curl::PostField.content('Content-Type',            query['Content-Type'])
      post_data << Curl::PostField.content('Content-Disposition',     query['Content-Disposition'])

      post_data << Curl::PostField.file('file', thingiverse_filename) { file_data }

      # post
      c = Curl::Easy.new(action) do |curl|
        # curl.verbose = true
        # can't follow redirect to finalize here because need to pass access_token for auth
        curl.follow_location = false
      end
      c.multipart_form_post = true
      c.http_post(post_data)

      if c.response_code == 303
        # finalize it
        response = Thingiverse::Connection.post(query['success_action_redirect'])
        raise ResponseError.new(response) unless response.success?
        Thingiverse::Files.new(response.parsed_response)
      else
        raise "#{c.response_code}: #{c.body_str}"
      end
    end

    def publish
      if @id.to_s == ""
        raise "Cannot publish until thing is saved"
      else
        response = Thingiverse::Connection.post("/things/#{id}/publish")
        raise ResponseError.new(response) unless response.success?

        thing = Thingiverse::Things.new(response.parsed_response)
      end

      thing.attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    def self.find(thing_id)
      response = Thingiverse::Connection.get("/things/#{thing_id}")
      raise ResponseError.new(response) unless response.success?
      self.new response.parsed_response
    end

    def self.newest(query = {})
      Thingiverse::Pagination.new(Thingiverse::Connection.get('/newest', :query => query), Thingiverse::Things)
    end

    def self.create(params)
      thing = self.new(params)

      response = Thingiverse::Connection.post('/things', :body => thing.attributes.to_json)
      raise ResponseError.new(response) unless response.success?

      self.new(response.parsed_response)
    end

  end
end
