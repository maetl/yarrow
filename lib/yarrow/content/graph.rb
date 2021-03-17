module Yarrow
  module Content
    # A directed graph of every element of content in the project.
    class Graph
      # Construct a graph collected from source content files.
      def self.from_source(config)
        new(SourceCollector.collect(config.input_dir), config)
      end

      attr_reader :graph, :config

      def initialize(graph, config)
        @graph = graph
        @config = config
      end

      def expand_pages
        expander = Yarrow::Content::CollectionExpander.new(config.content_types)
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
    end
  end
end
