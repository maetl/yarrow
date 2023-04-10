module Yarrow
  module Content
    module Expansion
      class DirectoryMerge < Aggregator
        def before_traversal(policy)
          @bundles = {}
          @current_collection = nil
          @current_entity = nil
        end

        def expand_source(container, policy)
          create_collection(container, policy.container, policy.container_const)
          @current_collection = container.props[:path]
        end

        def expand_directory(collection, policy)
          @current_entity = collection.props[:basename]
        end

        def expand_file(entity, policy)
          if entity.props[:basename] == @current_entity && entity.props[:ext] == ".md"
            create_entity(entity, @current_collection, policy.entity, policy.entity_const)
          else
            # TODO: attach static assets to the entity as well
            #puts "--> create_node label=:asset type=:asset name='#{entity.props[:basename]}' entity='#{@current_entity}'"
          end
        end
      end
    end
  end
end