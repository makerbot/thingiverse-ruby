module Thingiverse
  module DynamicAttributes
    def eigenclass
      class << self; self; end
    end
    
    attr_reader :attributes

    def initialize(attributes={})
      @attributes = attributes
      @attributes.each do |k,v|
        add_attribute(k, v)
      end
    end

    def method_missing(method_sym, *arguments, &block)
      method = (method_sym.instance_of? Symbol) ? method_sym.to_s : method_sym.clone
      
      if method.end_with? "="
        method.chomp! "="
        @attributes[method] = arguments[0]
        add_attribute(method, arguments[0])
      else
        super(method_sym, *arguments, &block)
      end
    end

    def add_attribute(name, value)
      eigenclass.class_eval{ attr_reader name.to_sym }
      instance_variable_set("@#{name}", value)
    end
  end
end