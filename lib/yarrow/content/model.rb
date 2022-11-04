module Yarrow
  module Content
    ContentSpec = Yarrow::Schema::Value.new(:namespace, :model) do
      def to_world
        "world"
      end
    end

    ContentPolicy = Yarrow::Schema::Value.new(
      :dir,
      :file,
      :expansion,
      :container,
      :record
    )

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
          strategy = TreeExpansion.new(graph)
          strategy.expand(policy)
        end
      end

      def policy_for(policy_key)
        @policies[policy_key]
      end
    end
  end
end
