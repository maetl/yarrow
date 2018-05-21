module Yarrow
  module Content
    class ContentType
      DEFAULT_EXTENSIONS = [".md", ".yml", ".htm"]

      def self.from_name(name)
        new(Yarrow::Configuration.new(collection: name.to_sym))
      end

      def initialize(properties)
        unless properties.respond_to?(:collection) || properties.respond_to?(:entity)
          raise "Must provide a collection name or entity name"
        end

        @properties = properties
      end

      def collection
        return @properties.collection if @properties.respond_to?(:collection)
        ActiveSupport::Inflector.pluralize(@properties.entity).to_sym
      end

      def entity
        return @properties.entity if @properties.respond_to?(:entity)
        ActiveSupport::Inflector.singularize(@properties.collection).to_sym
      end

      def extensions
        return @properties.extensions if @properties.respond_to?(:extensions)
        DEFAULT_EXTENSIONS
      end

      def match_path
        "."
      end
    end
  end
end
