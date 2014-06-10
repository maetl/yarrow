module Yarrow
  class ContentMap
    
    @@registry = {}

    def self.[](name)
      @@registry[name]
    end
    
    def self.define(name, &block)
      content_map = ContentMap.new
      content_map.instance_eval(&block)
      @@registry[name] = content_map.objects
    end
    
    def self.build(&block)
      content_map = ContentMap.new
      content_map.instance_eval(&block)
      content_map.objects
    end
    
    attr_reader :objects

    def initialize
      @objects = Hashie::Mash.new
    end

    def method_missing(method, *args, &block)
      @objects[method] = block ? ContentMap.build(&block) : args.first
    end

  end
end
