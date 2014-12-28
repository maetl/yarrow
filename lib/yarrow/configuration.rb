module Yarrow
  class Configuration < Hashie::Mash
   
    class << self

      def instance
        @@configuration || Hashie::Mash.new
      end

      def register(file)
        @@configuration = self.load(file)
      end

      def load(file)
        configuration = self.new(YAML.load_file(file))
        configuration
      end

    end
    
  end
end
