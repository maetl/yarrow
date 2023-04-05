module Yarrow
  module Content
    module Expansion
      class FilenameMap < Strategy
        # If match path represents entire content dir, then include the entire
        # content dir instead of scanning from a subfolder matching the name of
        # the collection.
        def find_start_node(policy)
          if policy.match_path == "."
            graph.n(:root).out(:directory)
          else
            graph.n(name: policy.match_path)
          end
        end

        def traverse_with(start_node, policy)
          #if policy.traversal == :tree
          if true
            start_node.depth_first
          else
            start_node.out(:file)
          end
        end

        def expand(policy)
          start_node = find_start_node(policy)

          traverse_with(start_node, policy).each do |node|
            if node.label == :directory
              if policy.match_path == node.props[:name]
                expand_directory(policy, node)
              end
              
            elsif node.label == :file
              expand_file_by_extension(policy, node)
            end
          end

          connect_expanded_entities
        end

        def expand_file_by_extension(policy, node)
          #p node.props
        end
      end
    end
  end
end
