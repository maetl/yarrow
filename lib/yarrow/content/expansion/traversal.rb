module Yarrow
  module Content
    module Expansion
      class Visitor
        attr_reader :graph

        def initialize(graph)
          @graph = graph
          @collections = {}
        end

        def before_traversal; end

        def expand_container; end

        def expand_collection; end

        def expand_entity; end

        def after_traversal; end

        private

        def create_collection(source_node, type, collection_const)
          # Create a collection node with attached resource model
          index = graph.create_node do |collection_node|
            attributes = {
              name: source_node.props[:name],
              title: source_node.props[:name].capitalize,
              body: ""
            }
            collection_node.label = :collection
            collection_node.props[:type] = type
            collection_node.props[:resource] = collection_const.new(attributes)
          end

          # Add this collection id to the lookup table for edge construction
          @collections[source_node.props[:path]] = index

          # Join the collection to its parent
          if @collections.key?(source_node.props[:entry].parent.to_s)
            graph.create_edge do |edge|
              edge.label = :child
              edge.from = @subcollections[node.props[:entry].parent.to_s].id
              edge.to = index.id
            end
          end
        end

        def create_entity(source_node, parent_collection, type, entity_const)
          # Create an entity node with attached resource model
          entity = graph.create_node do |entity_node|
            attributes = {
              name: source_node.props[:name],
              title: source_node.props[:name].capitalize,
              body: ""
            }
            entity_node.label = :entity
            entity_node.props[:type] = type
            entity_node.props[:resource] = entity_const.new(attributes)
          end

          if @collections.key?(parent_collection)
            graph.create_edge do |edge|
              edge.label = :child
              edge.from = @collections[parent_collection].id
              edge.to = entity.id
            end
          end
        end
      end

      class DirectFileMapping
        def expand_container(container, policy)
          puts "create_node label=:collection type=:#{policy.container} name='#{container.props[:basename]}'"
          @current_collection = container.props[:basename]
        end

        def expand_collection(collection, policy)
          puts "create_node label=:collection type=:#{policy.collection} name='#{collection.props[:basename]}' collection=#{@current_collection}"
          @current_collection = collection.props[:basename]
        end

        def expand_entity(entity, policy)
          puts "create_node label=:entity type=:#{policy.entity} name='#{entity.props[:basename]}' collection='#{@current_collection}"
        end

        def after_traversal(policy)

        end
      end

      class DirectoryAsBundle < Visitor
        def before_traversal(policy)
          @bundles = {}
          @current_collection = nil
          @current_entity = nil
        end

        def expand_container(container, policy)
          create_collection(container, policy.container, policy.container_const)
          @current_collection = container.props[:path]
        end

        def expand_collection(collection, policy)
          @current_entity = collection.props[:basename]
        end

        def expand_entity(entity, policy)
          if entity.props[:basename] == @current_entity && entity.props[:ext] == ".md"
            create_entity(entity, @current_collection, policy.entity, policy.entity_const)
          else
            # TODO: attach static assets to the entity as well
            #puts "--> create_node label=:asset type=:asset name='#{entity.props[:basename]}' entity='#{@current_entity}'"
          end
        end

        def after_traversal(policy)

        end
      end

      class BasenameFileBundle
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

      class Traversal
        attr_reader :graph, :policy

        def initialize(graph, policy)
          @graph = graph
          @policy = policy
          @observer = DirectoryAsBundle.new(graph)
        end

        # If match path represents entire content dir, then include the entire
        # content dir instead of scanning from a subfolder matching the name of
        # the collection.
        def start_node
          if policy.match_path == "."
            graph.n(:root).out(:directory)
          else
            graph.n(name: policy.match_path)
          end
        end

        def on_root_visited(root_node)
          @observer.expand_container(root_node, policy)
        end

        def on_directory_visited(dir_node)
          # TODO: match on potential directory extension/filter
          @observer.expand_collection(dir_node, policy)
        end

        def on_file_visited(file_node)
          # TODO: dispatch underscore prefix or index files separately
          # TODO: match on file extension
          @observer.expand_entity(file_node, policy)
        end

        def on_traversal_initiated
          @observer.before_traversal(policy)
        end

        def on_traversal_completed
          @observer.after_traversal(policy)
        end

        def expand
          on_traversal_initiated

          traversal = start_node.depth_first.each
          
          on_root_visited(traversal.next)

          loop do
            node = traversal.next
            case node.label
            when :directory then on_directory_visited(node)
            when :file then on_file_visited(node)
            end
          end

          on_traversal_completed
        end
      end
    end
  end
end