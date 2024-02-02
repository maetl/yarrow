module Yarrow
  module Content
    class Model
      def initialize(content_config)
        @expansion_policies = content_config.expansions.map do |policy|
          policy.prepare(content_config)
        end
      end

      def expand(graph)
        @expansion_policies.each do |policy|
          traversal = Expansion::Traversal.new(graph, policy)
          traversal.expand
        end
      end

      def aggregator_const(policy)
        case policy.expansion_strategy
        when :filename_map then Expansion::FilenameMap
        when :directory_merge then Expansion::DirectoryMerge
        else
          raise "No match strategy exists for :#{expansion}"
        end
      end
    end
  end
end
