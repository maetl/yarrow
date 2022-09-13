module Yarrow
  module Content
    class Expansion
      # If a list of object types is not provided, a default `pages` type is
      # created.
      def initialize(policies=nil)
        @policies = policies || [
          Yarrow::Content::Policy.from_name(:pages)
        ]
      end

      def expand(graph)
        @policies.each do |policy|
          expand_nested(graph, policy)
        end
      end

      def expand_nested(graph, policy)
        strategy = TreeExpansion.new(graph)
        strategy.expand(policy)
      end
    end
  end
end
