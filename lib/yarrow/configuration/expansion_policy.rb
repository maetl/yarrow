module Yarrow
  module Configuration
    class ExpansionPolicy
      DEFAULT_CONTAINER = :container
      DEFAULT_COLLECTION = :collection
      DEFAULT_ENTRY = :entry

      def self.defaults
        new({ container: DEFAULT_CONTAINER, collection: DEFAULT_COLLECTION, entry: DEFAULT_ENTRY })
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
        new({
          container: container.to_sym,
          collection: collection.to_sym,
          entry: entry.to_sym
        })
      end

      attr_reader :container, :collection, :entry

      def initialize(props)
        @container = props[:container] || DEFAULT_CONTAINER
        @collection = props[:collection] || DEFAULT_COLLECTION
        @entry = props[:entry] || DEFAULT_ENTRY
      end
    end
  end
end