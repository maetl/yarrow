module Yarrow
  module Content
    class Model
      def initialize(spec=nil, namespace=nil)
        @namespace = []
        @namespace << namespace unless namespace.nil?

        @policies = if spec.nil?
          spec = {
            root: ContentPolicy.new(
              expansion: :tree,
              dir: "*",
              file: "*.md",
              :container => :pages,
              :record => :page
            )
          }
        else
          spec.model
        end
      end

      def expand(graph)
        @policies.each_value do |policy|
          strategy = Expansion::Tree.new(graph)
          strategy.expand(policy)
        end
      end

      def policy_for(policy_key)
        @policies[policy_key]
      end
    end
  end
end
