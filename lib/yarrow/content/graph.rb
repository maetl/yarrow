module Yarrow
  module Content
    # A directed graph of every element of content in the project.
    class Graph
      # Construct a graph collected from files and directories in the configured
      # content directory.
      #
      # @return [Yarrow::Content::Graph]
      def self.from_source(config)
        new(SourceCollector.collect(config.content_dir), config)
      end

      attr_reader :graph, :config

      def initialize(graph, config)
        @graph = graph
        @config = config
      end

      def expand_pages
        expander = Yarrow::Content::CollectionExpander.new
        expander.expand(graph)
      end

      # List of source files.
      def files
        graph.nodes(:file)
      end

      # List of source directories.
      def directories
        graph.nodes(:directory)
      end

      # List of mapped content object collections
      def collections
        graph.nodes(:collection)
      end

      # List of mapped content object items
      def items
        graph.nodes(:item)
      end
    end
  end
end
