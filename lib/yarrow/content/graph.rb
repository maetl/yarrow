require "mementus"

module Mementus
  module Pipeline
    class Step
      # Monkeypatch extension to ensure each pipeline step supports enumerable
      # methods. Mostly used for #map. API needs to be fixed in the gem itself.
      include Enumerable
    end
  end
  module Structure
    class IncidenceList
      def inspect
        "<Mementus::Structure::IncidenceList>"
      end
    end
  end
  class Graph
    def inspect
      "<Mementus::Graph @structure=#{@structure.inspect} " +
        "nodes_count=#{nodes_count} edges_count=#{edges_count}>"
    end
  end
end

module Yarrow
  module Content
    # A directed graph of every element of content in the project.
    class Graph
      # Construct a graph collected from source content files.
      def self.from_source(config)
        new(SourceCollector.collect(config.input_dir), config)
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

      private

      def initialize(graph, config)
        @graph = graph
        @config = config
      end

      attr_reader :graph, :config
    end
  end
end
