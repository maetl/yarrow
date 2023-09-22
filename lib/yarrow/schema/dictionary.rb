module Yarrow
  module Schema
    # Specifies types plugged into each attribute slot and runs any required
    # validations and coercions.
    #
    # Current design throws on error rather than returns a boolean result.
    class Dictionary
      include Definitions

      # @param attrs_spec [Hash] defines the slots in the schema to validate against
      def initialize(attrs_spec={})
        @attrs_spec = attrs_spec.reduce({}) do |spec, (name, type_identifier)|
          spec[name] = resolve_type(type_identifier)
          spec
        end
      end

      def define_attribute(name, type_identifier)
        @attrs_spec[name] = resolve_type(type_identifier)
      end

      def attr_names
        @attrs_spec.keys
      end

      def cast(input)
        missing_attrs = @attrs_spec.keys.difference(input.keys)

        if missing_attrs.any?
          missing_attrs.each do |name|
            # TODO: add optional check
            raise "#{missing_attrs} wrong number of attributes" unless @attrs_spec[name].is_a?(Types::Any)
          end
        end

        mismatching_attrs = input.keys.difference(@attrs_spec.keys)

        raise "attribute #{mismatching_attrs} does not exist" if mismatching_attrs.any?

        input.reduce({}) do |converted, (name, value)|
          converted[name] = @attrs_spec[name].cast(value)
          converted
        end
      end

      def check(input)
        missing_attrs = @attrs_spec.keys.difference(input.keys)

        if missing_attrs.any?
          missing_attrs.each do |name|
            raise "wrong number of attributes" unless @attrs_spec[name].eql?(Type::Any)
          end
        end

        mismatching_attrs = input.keys.difference(@attrs_spec.keys)

        raise "attribute does not exist" if mismatching_attrs.any?

        input.each do |(name, value)|
          unless value.is_a?(@attrs_spec[name]) || @attrs_spec[name].eql?(Type::Any)
            raise "wrong data type"
          end
        end

        true
      end
    end
  end
end
