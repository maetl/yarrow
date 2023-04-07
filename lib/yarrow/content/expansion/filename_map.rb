module Yarrow
  module Content
    module Expansion
      class FilenameMap < Aggregator
        def expand_container(container, policy)
          create_collection(container, policy.container, policy.container_const)
          @current_collection = container.props[:basename]
        end

        def expand_collection(collection, policy)
          create_collection(collection, policy.collection, policy.collection_const)
          @current_collection = collection.props[:basename]
        end

        def expand_entity(entity, policy)
          if policy.match_by_extension(entity.props[:ext])
            create_entity(entity, @current_collection, policy.entity, policy.entity_const)
          end
        end
      end
    end
  end
end