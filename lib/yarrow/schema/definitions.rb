module Yarrow
  module Schema
    module Definitions
      DEFINED_TYPES = {
        string: Types::Instance.of(String),
        integer: Types::Instance.of(Integer),
        symbol: Types::Instance.of(Symbol),
        path: Types::Instance.of(Pathname).accept(String),
        any: Types::Any.new
      }

      def self.register(identifier, type_class)
        if DEFINED_TYPES.key?(identifier)
          raise "#{identifier} is already defined"
        end

        DEFINED_TYPES[identifier] = type_class
      end

      def resolve_type(identifier)
        #return identifier unless identifier.is_a?(Symbol)

        unless DEFINED_TYPES.key?(identifier)
          raise "#{identifier} is not defined"
        end

        return DEFINED_TYPES[identifier]
      end
    end
  end
end
