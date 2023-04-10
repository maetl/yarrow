module Yarrow
  module Content
    module Expansion
      class DirectoryMap < Aggregator
        def expand_source(container, policy)
          puts "create_node label=:collection type=:#{policy.container} name='#{container.props[:basename]}'"
          @current_collection = container.props[:basename]
        end

        def expand_directory(collection, policy)
          puts "create_node label=:collection type=:#{policy.collection} name='#{collection.props[:basename]}' collection=#{@current_collection}"
          @current_collection = collection.props[:basename]
        end

        def expand_file(entity, policy)
          puts "create_node label=:entity type=:#{policy.entity} name='#{entity.props[:basename]}' collection='#{@current_collection}"
        end
      end
    end
  end
end