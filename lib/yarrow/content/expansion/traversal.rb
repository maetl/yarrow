module Yarrow
  module Content
    module Expansion
      class Traversal
        attr_reader :graph, :policy, :aggregator

        def initialize(graph, policy)
          @graph = graph
          @policy = policy
          @aggregator = policy.aggregator_const.new(graph)
        end

        # If source path represents entire content dir, then include the entire
        # content dir instead of scanning from a subfolder matching the name of
        # the collection.
        def source_node
          if policy.source_path == "."
            graph.n(:root).out(:directory)
          else
            graph.n(name: policy.source_path)
          end
        end

        def visit_source(root_node)
          aggregator.expand_source(root_node, policy)
        end

        def visit_directory(dir_node)
          # TODO: match on potential directory extension/filter
          aggregator.expand_directory(dir_node, policy)
        end

        def visit_file(file_node)
          # TODO: dispatch underscore prefix or index files separately
          # TODO: match on file extension
          aggregator.expand_file(file_node, policy)
        end

        def start_traversal
          aggregator.before_traversal(policy)
        end

        def complete_traversal
          aggregator.after_traversal(policy)
        end

        def expand
          start_traversal

          traversal = source_node.depth_first.each
          
          visit_source(traversal.next)

          loop do
            node = traversal.next
            case node.label
            when :directory then visit_directory(node)
            when :file then visit_file(node)
            end
          end

          complete_traversal
        end
      end
    end
  end
end