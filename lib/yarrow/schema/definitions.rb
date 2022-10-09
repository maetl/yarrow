module Yarrow
  module Schema
    module Definitions
      DEFINED_TYPES = {
        #string: Types::String,
        string: Types::Instance.of(String),
        #integer: Types::Integer,
        integer: Types::Instance.of(Integer),
        path: Types::Instance.of(Pathname),
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
