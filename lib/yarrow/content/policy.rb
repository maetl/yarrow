module Yarrow
  module Content
    class Policy
      DEFAULT_HOME_NESTING = false

      DEFAULT_EXPANSION = :tree

      DEFAULT_EXTENSIONS = [".md", ".yml", ".htm"]

      DEFAULT_MATCH_PATH = "."

      # Construct a content policy from the given source specification.
      def self.from_spec(policy_label, policy_props, module_prefix="")
        # TODO: validate length, structure etc

        # If the spec holds a symbol value then treat it as a container => entity mapping
        if policy_props.is_a?(Symbol)
          new(policy_label, policy_props, DEFAULT_EXPANSION, DEFAULT_EXTENSIONS, DEFAULT_MATCH_PATH, module_prefix)

        # Otherwise scan through all the props and fill in any gaps
        else
          # Use explicit container name if provided
          container = if policy_props.key?(:container)
            policy_props[:container]
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
            if policy_props.key?(:container)
              Yarrow::Symbols.to_singular(policy_props[:container])
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
          new(container, entity, expansion, extensions, match_path, module_prefix)
        end
      end

      attr_reader :container, :entity, :expansion, :extensions, :match_path, :module

      def initialize(container, entity, expansion, extensions, match_path, module_prefix)
        @container = container
        @entity = entity
        @expansion = expansion
        @extensions = extensions
        @match_path = match_path
        @module_prefix = module_prefix
      end

      def container_const
        @container_const ||= Yarrow::Symbols.to_module_const([module_prefix, container])
      end

      def entity_const
        @entity_const ||= Yarrow::Symbols.to_module_const([module_prefix, entity])
      end
    end
  end
end
