module Yarrow
  module Content
    class Model
      def initialize(content_config)
        @policies = {}
        content_config.source_map.each_entry do |policy_label, policy_spec|
          @policies[policy_label] = Policy.from_spec(policy_label, policy_spec)
        end
      end

      def expand(graph)
        @policies.each_value do |policy|
          strategy = Expansion::Tree.new(graph)
          strategy.expand(policy)
        end
      end

      def policy_for(policy_label)
        @policies[policy_label]
      end
    end
  end
end
