module Yarrow
  module Web
    class Manifest
      def self.build(graph)
        manifest = new
        manifest.set_graph(graph)

        graph.n(:collection).each do |collection|
          # TODO: raise error if both content_only and index_only are set
          index = nil

          # If the collection is tagged :index_only then skip adding individual documents
          unless collection.props[:index_only]
            collection.out(:entity).each do |entity|
              #if item[:entity].status.to_sym == :published
              if entity.props[:resource].name == "index"
                index = entity
              else
                manifest.add_document(entity_context(entity))
              end
              #end
            end
          end

          # If the collection is tagged :content_only then skip top level listing/index
          unless collection.props[:content_only]
            if index
              manifest.add_document(collection_index_context(collection, index))
            else
              manifest.add_document(collection_context(collection))
            end
          end
        end

        manifest
      end

      attr_reader :documents, :assets, :graph

      def initialize
        @documents = []
        @assets = []
      end

      # Used for dot debugging
      def set_graph(graph)
        @graph = graph
      end

      def add_document(document)
        @documents << document
      end

      def add_asset(asset)
        @assets << asset
      end

      def self.collection_context(collection)
        IndexDocument.new(collection, nil, true)
      end

      def self.collection_index_context(collection, entity)
        IndexDocument.new(collection, entity, false)
      end

      def self.entity_context(entity)
        Document.new(entity, false)
      end
    end
  end
end
