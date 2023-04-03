module Yarrow
  module Content
    module Expansion
      class FileList < Strategy
        def expand(policy)
          start_node = graph.n(:root).out(name: policy.container.to_s)

          start_node.out(:files).each do |file_node|

          end
        end
      end
    end
  end
end