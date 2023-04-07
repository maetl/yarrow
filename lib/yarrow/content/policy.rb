module Yarrow
  module Content
    class Policy
      DEFAULT_EXPANSION = :filename_map

      DEFAULT_EXTENSIONS = [".md", ".yml", ".htm"]

      DEFAULT_SOURCE_PATH = "."

      MODULE_SEPARATOR = "::"

      # Construct a content policy from the given source specification.
      def self.from_spec(policy_label, policy_props, module_prefix="")
        # TODO: validate length, structure etc

        # If the spec holds a symbol value then treat it as an entity mapping
        if policy_props.is_a?(Symbol)
          new(
            policy_label,
            policy_label,
            policy_props,
            DEFAULT_EXPANSION,
            DEFAULT_EXTENSIONS,
            policy_label.to_s,
            module_prefix
          )

        # If the spec holds a string value then treat it as a source path mapping
        elsif policy_props.is_a?(String)
          new(
            policy_label,
            policy_label,
            Yarrow::Symbols.to_singular(policy_label),
            DEFAULT_EXPANSION,
            DEFAULT_EXTENSIONS,
            policy_props,
            module_prefix
          )

        # Otherwise scan through the spec and fill in any gaps
        else
          # Use explicit collection name if provided
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

          # Use explicit container name if provided
          container = if policy_props.key?(:container)
            policy_props[:container]
          else
            collection
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

          # If match path is provided, treat it as a basename
          source_path = if policy_props.key?(:source_path)
            policy_props[:source_path]
          else
            DEFAULT_SOURCE_PATH
          end

          # Construct the new policy
          new(
            container,
            collection,
            entity,
            expansion,
            extensions,
            source_path,
            module_prefix
          )
        end
      end

      attr_reader :container, :collection, :entity, :expansion, :extensions, :source_path, :module_prefix

      def initialize(container, collection, entity, expansion, extensions, source_path, module_prefix)
        @container = container
        @collection = collection
        @entity = entity
        @expansion = expansion
        @extensions = extensions
        @source_path = source_path
        @module_prefix = module_prefix.split(MODULE_SEPARATOR)
      end

      def container_const
        @container_const ||= Yarrow::Symbols.to_module_const([*module_prefix, container])
      end

      def collection_const
        begin
          @collection_const ||= Yarrow::Symbols.to_module_const([*module_prefix, collection])
        rescue NameError
          raise NameError, "cannot map undefined entity `#{collection}`"
        end
      end

      def entity_const
        @entity_const ||= Yarrow::Symbols.to_module_const([*module_prefix, entity])
      end

      def aggregator_const
        case expansion
        when :filename_map then Expansion::FilenameMap
        when :directory_merge then Expansion::DirectoryMerge
        else
          raise "No match strategy exists for :#{expansion}"
        end
      end

      def match_by_extension(candidate)
        extensions.include?(candidate)
      end
    end
  end
end
