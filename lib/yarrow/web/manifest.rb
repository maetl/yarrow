module Yarrow
  module Web
    class Manifest
      def self.build(graph)
        manifest = new

        graph.n(:collection).each do |collection|
          # TODO: raise error if both content_only and index_only are set
          index = nil

          # If the collection is tagged :index_only then skip adding individual documents
          unless collection.props[:index_only]
            collection.out(:item).each do |item|
              #if item[:entity].status.to_sym == :published
              if item.props[:name] == "index"
                index = item
              else
                manifest.add_document(item_context(item))
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

      attr_reader :documents, :assets

      def initialize
        @documents = []
        @assets = []
      end

      def add_document(document)
        @documents << document
      end

      def add_asset(asset)
        @assets << asset
      end

      def self.collection_context(collection)
        Document.new(collection, collection.in(:collection).first, true)
      end

      def self.collection_index_context(collection, item)
        Document.new(item, collection.in(:collection).first, false)
      end

      def self.item_context(item)
        Document.new(item, item.in(:collection).first, false)
      end
    end
  end
end
