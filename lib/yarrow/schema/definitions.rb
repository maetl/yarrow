module Yarrow
  module Schema
    module Definitions
      DEFINED_TYPES = {
        string: Types::Instance.of(String),
        integer: Types::Instance.of(Integer),
        symbol: Types::Instance.of(Symbol).accept(String, :to_sym),
        path: Types::Instance.of(Pathname).accept(String),
        any: Types::Any.new,
        array: Types::List.of(Types::Any),
        hash: Types::Map.of(Symbol => Types::Any)
      }

      TEMPLATE_TYPES = {
        list: Types::List,
        map: Types::Map
      }

      def self.register(identifier, type_class)
        if DEFINED_TYPES.key?(identifier)
          raise "#{identifier} is already defined"
        end

        DEFINED_TYPES[identifier] = type_class
      end

      def resolve_type(identifier)
        # Type is directly resolvable from the definition table
        return DEFINED_TYPES[identifier] if DEFINED_TYPES.key?(identifier)

        if identifier.is_a?(Hash)
          # If type identifier is a compound template extract its key and value mapping
          key_id = identifier.keys.first
          value_id = identifier.values.first

          # Check if the given key is defined as a template type
          unless TEMPLATE_TYPES.key?(key_id)
            raise "compound type #{key_id} is not defined"
          end

          # Get reference to the type class we want to resolve
          template_type = TEMPLATE_TYPES[key_id]
          
          # Resolve the type to an instance depending on structure of its template args
          resolved_type = if value_id.is_a?(Hash)
            # Map template with two argument constructor
            template_type.new(
              resolve_type(value_id.keys.first),
              resolve_type(value_id.values.first)
            )
          else
            # Use the single arg constructor with the given unit type
            template_type.of(resolve_type(value_id).unit)
          end

          # Cache the resolved type for later reference
          DEFINED_TYPES[identifier] = resolved_type
          
          # Return the resolve type
          resolved_type
        else
          # Not a compound template so we know it’s missing in the lookup table
          raise "type #{identifier} is not defined"
        end
      end
    end
  end
end
