require "recursive_open_struct"
require "yaml"

module Yarrow
  class Configuration
   
    def self.load(file)
      klass = self.new(YAML.load_file(file))
      klass
    end
    
    def initialize(data)
      @settings = RecursiveOpenStruct.new(data)
    end
    
    def method_missing(method, *args, &block)
      @settings.send(method, *args, &block)
    end
    
    def merge(data)
    end
    
    def append(data)
    end
    
  end
end