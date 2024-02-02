module Yarrow
  module Output
    class Target
      attr_reader :graph, :output_config
      
      def initialize(graph, output_config)
        @graph = graph
        @output_config = output_config
      end

      def reconcile
        case output_config.reconcile.match
        when "collection/resource" then traverse_by_path(:collection, :resource)
        when "collection" then traverse_by_label(:collection)
        when "resource" then traverse_by_label(:resource)
        end
      end

      private

      def traverse_by_label(label)
        graph.n(label).each do |node|
          puts "§ #{label} node #{node.label} #{node.props}"
        end
      end

      def traverse_by_path(parent_label, child_label)
        graph.n(parent_label).each do |collection_node|
          puts "§ #{parent_label} node #{collection_node.label} #{collection_node.props}"
          collection_node.out(child_label).each do |resource_node|
            puts "§ #{child_label} node #{resource_node.label} #{resource_node.props}"
          end
        end
      end
    end
  end
end
