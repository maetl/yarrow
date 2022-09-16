module Yarrow
  module Content
    class Expansion
      def initialize(model)
        @model = model
      end

      def expand(graph)
        @model.each_policy do |policy|
          strategy = TreeExpansion.new(graph)
          strategy.expand(policy)
        end
      end
    end
  end
end
