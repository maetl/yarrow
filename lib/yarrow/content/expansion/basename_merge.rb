module Yarrow
  module Content
    module Expansion
      class BasenameMerge < Aggregator
        def before_traversal(policy)
          @bundles = {}
          @container_collection = nil
          @entity_bundles = {}
          @entity_collections = {}
        end
      
        def expand_container(container, policy)
          puts "create_node label=:collection type=:#{policy.collection} name='#{container.props[:basename]}'"
          @container_collection = container.props[:basename]
        end
      
        def expand_collection(collection, policy)
          if @container_collection == collection.props[:entry].parent.to_s
            puts "create_node label=:collection type=:#{policy.entity} name='#{collection.props[:basename]}' collection='#{@container_collection}'"
          end
        end
      
        def expand_entity(entity, policy)
          unless @entity_bundles.key?(entity.props[:basename])
            @entity_bundles[entity.props[:basename]] = []
          end
      
          @entity_bundles[entity.props[:basename]] << entity
          @entity_collections[entity.props[:basename]] = @container_collection
        end
      
        def after_traversal(policy)
          @entity_bundles.each do |basename, bundle|
            puts "create_node label=:resource type=:#{policy.entity} name='#{basename}' collection='#{@entity_collections[basename]}'"
      
            bundle.each do |asset|
              puts "create_node label=:asset extension='#{asset.props[:ext]}' resource='#{basename}'"
            end
          end
        end
      end
    end
  end
end