module Yarrow
  class Configuration < Hashie::Mash
   
    def self.load(file)
      configuration = self.new(YAML.load_file(file))
      configuration
    end
    
  end
end