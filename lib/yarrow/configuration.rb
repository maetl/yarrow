module Yarrow

  ##
  # Hash-like object containing runtime configuration values. Can be accessed indifferently
  # via object style lookups or symbol keys.
  #
  class Configuration < Hashie::Mash
   
    class << self

      ##
      # Provides access to the registered global configuration.
      #
      # If no configuration is registered, returns a blank object.
      #
      # @return [Yarrow::Configuration]
      #
      def instance
        @@configuration ||= self.new
      end

      ##
      # Loads and registers a global configuration object.
      #
      # @param [String] path to YAML file
      #
      def register(file)
        @@configuration = self.load(file)
      end

      ##
      # Clears the global configuration to the empty default.
      #
      def clear
        @@configuration = self.new
      end


      ##
      # Merges the given configuration or hash-like object with the
      # registered global configuration.
      #
      # @param [Hash, Hashie::Mash, Yarrow::Configuration]
      #
      def merge(config)
        instance.deep_merge!(config)
      end

      ##
      # Loads a configuration object from the given YAML file.
      #
      # @param [String] path to YAML file
      #
      # @return [Yarrow::Configuration]
      #
      def load(file)
        self.new(YAML.load_file(file))
      end

    end
    
  end

  ##
  # Embeds global configuration access in a client object.
  #
  module Configurable

    ##
    # Provides access to the registered global configuration. This can
    # be overriden by subclasses to customize behaviour (eg: in test cases).
    #
    # @return [Yarrow::Configuration]
    #
    def config
      Configuration.instance
    end

  end

end
