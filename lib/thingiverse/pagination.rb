module Thingiverse
  require "forwardable"

  class Pagination
    include Enumerable
    extend Forwardable
    
    attr_reader :response, :object
    attr_reader :current_page, :total_pages, :first_url, :last_url, :next_url, :prev_url
    
    def initialize(response, object)
      @response = response
      @object   = object

      # TODO: provide more debug info and raise a custom exception
      raise "#{@response.code}: #{JSON.parse(@response.body)['error']}" unless @response.success?
      
      @objects = @response.parsed_response.collect do |attrs|
        @object.new attrs
      end

      if @response.headers.include?("link")
        @response.headers["link"].split(",").each do |link|
          url, rel = link.split(";").collect{|p| p.gsub(/\<|\>|rel\=|\"/,'').strip}
          instance_variable_set("@#{rel}_url", url)
          url_params = CGI.parse(url)

          case rel
          when "first"
            @first_url = url
          when "last"
            @total_pages = url_params["page"][0].to_i
            @last_url = url
          when "next"
            @current_page = url_params["page"][0].to_i - 1
            @next_url = url
          when "prev"
            @current_page = url_params["page"][0].to_i + 1
            @prev_url = url
          end
        end
      end
    end

    def_delegators :@objects, :<<, :[], :[]=, :last, :size
    
    def method_missing(meth, *args, &block)
      if meth.to_s =~ /^(.*)_page$/
        get_url_page($1, *args, &block)
      else
        super
      end
    end
    
    def get_url_page(which, *args, &block)
      url = instance_variable_get("@#{which}_url")
      Thingiverse::Pagination.new(Thingiverse::Connection.get(url), @object) if url
    end
    
    def each(&block)
      @objects.each(&block)
    end    
  end
end
