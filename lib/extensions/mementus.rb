require "mementus"

module Mementus
  module Pipeline
    class Step
      # Monkeypatch extension to ensure each pipeline step supports enumerable
      # methods. Mostly used for #map. API needs to be fixed in the gem itself.
      include Enumerable

      def to
        Step.new(map { |edge| edge.to }, Pipe.new(graph), graph)
      end

      def props
        Step.new(map { |node| node.props }, Pipe.new(graph), graph)
      end

      # def props
      #   node_props = source.inject([]) do |result, node|
      #     result.concat(node.props)
      #   end

      #   Step.new(node_props, Pipe.new(graph), graph)
      # end
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

    def to_dot
      statements = []

      nodes.each do |node|
        label = if node.props.key?(:type)
          "#{node.label}: #{node.props[:type]}"
        elsif node.props.key?(:name)
          "#{node.label}: #{node.props[:name]}"
        else
          node.label
        end

        statements << "#{node.id} [label=\"#{label}\"]"
      end

      edges.each do |edge|
        statements << "#{edge.from.id} -> #{edge.to.id} [label=\"#{edge.label}\"];"
      end

      "digraph {\n#{statements.join("\n")}\n}"
    end
  end

  class Node
    def merge_props(data)
      next_props = props.merge(data)
      @props = next_props.freeze
    end
  end
end
