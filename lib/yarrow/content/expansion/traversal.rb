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

        # If match path represents entire content dir, then include the entire
        # content dir instead of scanning from a subfolder matching the name of
        # the collection.
        def start_node
          if policy.match_path == "."
            graph.n(:root).out(:directory)
          else
            graph.n(name: policy.match_path)
          end
        end

        def on_root_visited(root_node)
          aggregator.expand_container(root_node, policy)
        end

        def on_directory_visited(dir_node)
          # TODO: match on potential directory extension/filter
          aggregator.expand_collection(dir_node, policy)
        end

        def on_file_visited(file_node)
          # TODO: dispatch underscore prefix or index files separately
          # TODO: match on file extension
          aggregator.expand_entity(file_node, policy)
        end

        def on_traversal_initiated
          aggregator.before_traversal(policy)
        end

        def on_traversal_completed
          aggregator.after_traversal(policy)
        end

        def expand
          on_traversal_initiated

          traversal = start_node.depth_first.each
          
          on_root_visited(traversal.next)

          loop do
            node = traversal.next
            case node.label
            when :directory then on_directory_visited(node)
            when :file then on_file_visited(node)
            end
          end

          on_traversal_completed
        end
      end
    end
  end
end