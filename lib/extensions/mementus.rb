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

  class Node
    def merge_props(data)
      next_props = props.merge(data)
      @props = next_props.freeze
    end
  end
end
