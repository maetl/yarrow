module Yarrow
  module Configuration
    class ExpansionPolicy
      DEFAULT_CONTAINER = :container
      DEFAULT_COLLECTION = :collection
      DEFAULT_ENTRY = :entry
      DEFAULT_AGGREGATOR = :filename_map
      MODULE_SEPARATOR = "::"

      def self.defaults
        new(DEFAULT_AGGREGATOR, { container: DEFAULT_CONTAINER, collection: DEFAULT_COLLECTION, entry: DEFAULT_ENTRY })
      end

      def self.from_node(expansion_node)
        policy_props = expansion_node.properties.transform_keys(&:to_sym)

        # TODO: this may not be needed if defaults are used properly
        if policy_props.empty?
          raise "No policy properties provided for #{expansion_node.name}"
        end

        # Use explicit container name if provided
        container = if policy_props.key?(:container)
          policy_props[:container].value
        else
          # If an entry name is provided use its plural for the container name.
          # Otherwise fall back to the collection name or default.
          if policy_props.key?(:entity)
            Yarrow::Symbols.to_plural(policy_props[:entity].value)
          elsif policy_props.key?(:collection)
            policy_props[:collection].value
          end
        end

        # Use explicit collection name if provided
        collection = if policy_props.key?(:collection)
          policy_props[:collection].value
        else
          # If an entity name is provided use its plural for the container name.
          # Otherwise fall back to a container name or policy label. 
          if policy_props.key?(:entity)
            Yarrow::Symbols.to_plural(policy_props[:entity].value)
          elsif policy_props.key?(:container)
            policy_props[:container].value
          end
        end

        # Use explicit entry name if provided
        entry = if policy_props.key?(:entry)
          policy_props[:entry].value
        else
          if policy_props.key?(:collection)
            Yarrow::Symbols.to_singular(policy_props[:collection].value)
          elsif policy_props.key?(:container)
            Yarrow::Symbols.to_singular(policy_props[:container].value)
          end
        end

        # Arrange constructor props
        new(
          DEFAULT_AGGREGATOR,
          {
            container: container.to_sym,
            collection: collection.to_sym,
            entry: entry.to_sym
          }
        )
      end

      attr_reader :aggregator, :container, :collection, :entry, :extensions

      def initialize(aggregator, props)
        @aggregator = aggregator
        @container = props[:container] || DEFAULT_CONTAINER
        @collection = props[:collection] || DEFAULT_COLLECTION
        @entry = props[:entry] || DEFAULT_ENTRY
        @extensions = [".md"]
      end

      def source_path
        "."
      end

      def prepare(content_config)
        @module_prefix_parts = content_config.module.split(MODULE_SEPARATOR)
        self
      end

      def container_const
        @container_const ||= Yarrow::Symbols.to_module_const([*module_prefix_parts, container])
      end

      def collection_const
        @collection_const ||= Yarrow::Symbols.to_module_const([*module_prefix_parts, collection])
      end

      def entry_const
        @entry_const ||= Yarrow::Symbols.to_module_const([*module_prefix_parts, entry])
      end

      def aggregator_const
        case aggregator
        when :filename_map then Yarrow::Content::Expansion::FilenameMap
        when :directory_merge then Yarrow::Content::Expansion::DirectoryMerge
        else
          raise "No aggregation strategy exists for :#{aggregator}"
        end
      end

      def match_by_extension(candidate)
        extensions.include?(candidate)
      end

      private

      attr_reader :module_prefix_parts
    end
  end
end