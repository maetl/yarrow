module Yarrow
  module ContentConfig
    ContentSpec = Yarrow::Schema::Value.new(
      :namespace,
      :model
    )

    ContentPolicy = Yarrow::Schema::Value.new(
      :folder,
      :file,
      :expansion,
      :container,
      :entity
    )

    class Model
      def initialize(spec)
        @namespace = []
        @namespace << spec.namespace if spec.respond_to?(:namespace)

        unless spec.respond_to?(:model)
          raise "Missing content model definition"
        end

        unless spec.model.is_a?(Hash)
          raise "Invalid content model definition"
        end

        @policies = {}

        spec.model.each do |policy_key, policy_spec|
          @policies[policy_key.to_sym] = policy_spec
        end
      end

      def policy_for(policy_key)
        @policies[policy_key]
      end
    end
  end
  module Content
    class Policy
      Options = Yarrow::Schema::Value.new(
        :container,
        :entity,
        :extensions,
        :match_path
      )

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
