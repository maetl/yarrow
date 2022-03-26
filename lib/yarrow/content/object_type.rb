gem "strings-inflection"

module Yarrow
  module Content
    class ObjectType
      Value = Yarrow::Schema::Value.new(:collection, :entity, :extensions)

      DEFAULT_EXTENSIONS = [".md", ".yml", ".htm"]

      def self.from_name(name)
        new(Value.new(collection: name.to_sym))
      end

      def initialize(properties)
        unless properties.respond_to?(:collection) || properties.respond_to?(:entity)
          raise "Must provide a collection name or entity name"
        end

        @properties = properties
      end

      def collection
        return @properties.collection if @properties.collection
        Yarrow::Symbols.to_plural(@properties.entity)
      end

      def entity
        return @properties.entity if @properties.entity
        Yarrow::Symbols.to_singular(@properties.collection)
      end

      def extensions
        return @properties.extensions if @properties.extensions
        DEFAULT_EXTENSIONS
      end

      def match_path
        "."
      end
    end
  end
end
