module Yarrow
  module Content
    module Expansion
      class Aggregator
        attr_reader :graph

        def initialize(graph)
          @graph = graph
          @collections = {}
        end

        def before_traversal(policy)
        end

        def expand_source(container, policy)
        end

        def expand_directory(collection, policy)
        end

        def expand_file(entity, policy)
        end

        def after_traversal(policy)
        end

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
              edge.from = @collections[source_node.props[:entry].parent.to_s].id
              edge.to = index.id
            end
          end
        end

        def create_entity(source_node, parent_path, type, entity_const)
          contents = Yarrow::Format.read(source_node.props[:path])

          # Create an entity node with attached resource model
          entity = graph.create_node do |entity_node|
            attributes = {
              name: source_node.props[:basename],
              title: Yarrow::Symbols.to_text(source_node.props[:basename]),
              body: contents.document.to_s
            }.merge(contents.metadata)
            
            entity_node.label = :entity
            entity_node.props[:type] = type
            entity_node.props[:resource] = entity_const.new(attributes)
          end

          graph.create_edge do |edge|
            edge.label = :source
            edge.from = entity.id
            edge.to = source_node.id
          end

          if @collections.key?(parent_path)
            graph.create_edge do |edge|
              edge.label = :child
              edge.from = @collections[parent_path].id
              edge.to = entity.id
            end
          end
        end

        def connect_entity(entity, collection)
        end
      end
    end
  end
end