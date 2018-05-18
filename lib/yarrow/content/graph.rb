require "mementus"

module Mementus
  module Pipeline
    class Step
      # Monkeypatch extension to ensure each pipeline step supports enumerable
      # methods. Mostly used for #map. API needs to be fixed in the gem itself.
      include Enumerable
    end
  end
end

module Yarrow
  module Content
    # A directed graph of every element of content in the project.
    class Graph
      # Construct a graph collected from source content files.
      def self.from_source(config)
        new(SourceCollector.collect(config.input_dir))
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

      def initialize(graph)
        @graph = graph
      end

      attr_reader :graph
    end
  end
end
