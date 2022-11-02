module Yarrow
  module Content
    class Policy
      Options = Yarrow::Schema::Value.new(
        :container,
        :entity,
        :extensions,
        :match_path
      )

      DEFAULT_HOME_NESTING = false

      DEFAULT_EXTENSIONS = [".md", ".yml", ".htm"]

      DEFAULT_MATCH_PATH = "."

      def self.from_name(name)
        new(Options.new(container: name.to_sym))
      end

      def initialize(properties)
        unless properties.respond_to?(:container) || properties.respond_to?(:entity)
          raise "Must provide a container name or entity name"
        end

        @properties = properties
      end

      def container
        return @properties.container if @properties.container
        Yarrow::Symbols.to_plural(@properties.entity)
      end

      def entity
        return @properties.entity if @properties.entity
        Yarrow::Symbols.to_singular(@properties.container)
      end

      def extensions
        return @properties.extensions if @properties.extensions
        DEFAULT_EXTENSIONS
      end

      def match_path
        return @properties.match_path if @properties.match_path
        DEFAULT_MATCH_PATH
      end
    end
  end
end
