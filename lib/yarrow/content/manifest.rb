module Yarrow
  module Content
    class Manifest
      def self.build(graph)
        manifest = new

        graph.n(:collection).each do |collection|

          unless collection.props[:content_only]
            manifest.add_document(collection_context(collection))
          end

          unless collection.props[:index_only]
            collection.out(:item).each do |item|
              #if item[:entity].status.to_sym == :published
              manifest.add_document(item_context(item))
              #end
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

      def self.collection_context(collection)
        Yarrow::Output::Context.new(
          parent: collection.in(:collection).first,
          name: collection.props[:name],
          #url: collection.props[:url],
          title: collection.props[:title],
          type: collection.props[:type]
        )
      end

      def self.item_context(item)
        Yarrow::Output::Context.new(
          parent: item.in(:collection).first,
          name: item.props[:name],
          #url: item.props[:url],
          title: item.props[:title],
          type: item.props[:type]
        )
      end

      def add_document(document)
        @documents << document
      end

      def add_asset(asset)
        @assets << asset
      end
    end
  end
end
