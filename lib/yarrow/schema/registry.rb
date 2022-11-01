module Yarrow
  module Schema
    class Registry
      def type(identifier, type_class)
        Definitions.register(identifier, type_class)
      end
    end

    def self.define(&block)
      instance = Registry.new
      instance.instance_eval(&block)
    end
  end
end
