Yarrow::Schema::Definitions.register(:extension_list, Yarrow::Schema::Types::List.of(String))

module Yarrow
  module Content
    class Policy < Yarrow::Schema::Entity
      # TODO: document meaning and purpose of each attribute
      attribute :container, :symbol
      attribute :collection, :symbol
      attribute :entity, :symbol
      attribute :expansion, :symbol
      attribute :extensions, :extension_list
      attribute :source_path, :string
      attribute :module_prefix, :string

      DEFAULT_EXPANSION = :filename_map

      DEFAULT_EXTENSIONS = [".md", ".yml", ".htm"]

      DEFAULT_SOURCE_PATH = "."

      DEFAULT_MODULE_PREFIX = ""

      MODULE_SEPARATOR = "::"

      # Construct a content policy from the given source specification.
      def self.from_spec(policy_label, policy_props=DEFAULT_SOURCE_PATH, module_prefix=DEFAULT_MODULE_PREFIX)
        # TODO: validate length, structure etc

        # If the spec holds a symbol value then treat it as an entity mapping
        if policy_props.is_a?(Symbol)
          new({
            container: policy_label,
            collection: policy_label,
            entity: policy_props,
            expansion: DEFAULT_EXPANSION,
            extensions: DEFAULT_EXTENSIONS,
            source_path: policy_label.to_s,
            module_prefix: module_prefix
          })

        # If the spec holds a string value then treat it as a source path mapping
        elsif policy_props.is_a?(String)
          new(
            container: policy_label,
            collection: policy_label,
            entity: Yarrow::Symbols.to_singular(policy_label),
            expansion: DEFAULT_EXPANSION,
            extensions: DEFAULT_EXTENSIONS,
            source_path: policy_props,
            module_prefix: module_prefix
          )

        # Otherwise scan through the spec and fill in any gaps
        else
          # Use explicit collection name if provided
          collection = if policy_props.key?(:collection)
            policy_props[:collection]
          else
            # If an entity name is provided use its plural for the container name.
            # Otherwise fall back to a container name or policy label. 
            if policy_props.key?(:entity)
              Yarrow::Symbols.to_plural(policy_props[:entity])
            else
              Yarrow::Symbols.to_plural(policy_label)
            end
          end

          # Use explicit container name if provided. Otherwise fall back to the collection name.
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
          new({
            container: container,
            collection: collection,
            entity: entity,
            expansion: expansion,
            extensions: extensions,
            source_path: source_path,
            module_prefix: module_prefix
          })
        end
      end

      def module_prefix_parts
        module_prefix.split(MODULE_SEPARATOR)
      end

      def container_const
        @container_const ||= Yarrow::Symbols.to_module_const([*module_prefix_parts, container])
      end

      def collection_const
        begin
          @collection_const ||= Yarrow::Symbols.to_module_const([*module_prefix_parts, collection])
        rescue NameError
          raise NameError, "cannot map undefined entity `#{collection}`"
        end
      end

      def entity_const
        @entity_const ||= Yarrow::Symbols.to_module_const([*module_prefix_parts, entity])
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
