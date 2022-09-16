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

      def each_policy(&block)
        @policies.each_value(&block)
      end

      def policy_for(policy_key)
        @policies[policy_key]
      end
    end
  end
end
