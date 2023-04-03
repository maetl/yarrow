module Yarrow
  module Content
    class Policy
      DEFAULT_HOME_NESTING = false

      DEFAULT_EXPANSION = :tree

      DEFAULT_EXTENSIONS = [".md", ".yml", ".htm"]

      DEFAULT_MATCH_PATH = "."

      MODULE_SEPARATOR = "::"

      # Construct a content policy from the given source specification.
      def self.from_spec(policy_label, policy_props, module_prefix="")
        # TODO: validate length, structure etc

        # If the spec holds a symbol value then treat it as a container => entity mapping
        if policy_props.is_a?(Symbol)
          new(policy_label, policy_props, DEFAULT_EXPANSION, DEFAULT_EXTENSIONS, DEFAULT_MATCH_PATH, module_prefix)

        # Otherwise scan through all the props and fill in any gaps
        else
          # Use explicit container name if provided
          collection = if policy_props.key?(:collection)
            policy_props[:collection]
          else
            # If an entity name is provided use its plural for the container name
            if policy_props.key?(:entity)
              Yarrow::Symbols.to_plural(policy_props[:entity])
            else
              Yarrow::Symbols.to_plural(policy_label)
            end
          end

          # Use explicit entity name if provided
          entity = if policy_props.key?(:entity)
            policy_props[:entity]
          else
            if policy_props.key?(:collection)
              Yarrow::Symbols.to_singular(policy_props[:collection])
            else
              Yarrow::Symbols.to_singular(policy_label)
            end
          end

          # Set expansion strategy
          expansion = if policy_props.key?(:expansion)
            policy_props[:expansion]
          else
            DEFAULT_EXPANSION
          end

          # Set list of extensions to turn into documents
          extensions = if policy_props.key?(:extensions)
            policy_props[:extensions]
          else
            DEFAULT_EXTENSIONS
          end

          # TODO: handle this in expansion strategies
          match_path = DEFAULT_MATCH_PATH

          # Construct the new policy
          new(collection, entity, expansion, extensions, match_path, module_prefix)
        end
      end

      attr_reader :collection, :entity, :expansion, :extensions, :match_path, :module_prefix

      def initialize(collection, entity, expansion, extensions, match_path, module_prefix)
        @collection = collection
        @entity = entity
        @expansion = expansion
        @extensions = extensions
        @match_path = match_path
        @module_prefix = module_prefix.split(MODULE_SEPARATOR)
      end

      def collection_const
        begin
          @collection_const ||= Yarrow::Symbols.to_module_const([*module_prefix, collection])
        rescue NameError
          raise NameError, "cannot map undefined entity `#{collection}`"
        end
      end

      #alias_method :container, :collection
      #alias_method :container_const, :collection_const

      def entity_const
        @entity_const ||= Yarrow::Symbols.to_module_const([*module_prefix, entity])
      end
    end
  end
end
