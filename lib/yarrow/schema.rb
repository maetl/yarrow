module Yarrow
  module Schema
    module Type
      class Any
      end
    end

    ##
    # Checks values plugged into each slot and runs any required validations
    # (validations not yet implemented).
    #
    # Current design throws on error rather than returns a boolean result.
    class Validator
      # @param fields_spec [Hash] defines the slots in the schema to validate against
      def initialize(fields_spec)
        @spec = fields_spec
      end

      def check(fields)
        missing_fields = @spec.keys.difference(fields.keys)

        if missing_fields.any?
          missing_fields.each do |field|
            raise "wrong number of args" unless @spec[field].eql?(Type::Any)
          end
        end

        mismatching_fields = fields.keys.difference(@spec.keys)

        raise "key does not exist" if mismatching_fields.any?

        fields.each do |(field, value)|
          raise "wrong data type" unless value.is_a?(@spec[field]) || @spec[field].eql?(Type::Any)
        end

        true
      end
    end

    ##
    # Value object (with comparison by value equality). This just chucks back a
    # Ruby struct but wraps the constructor with method advice that handles
    # validation (and eventually type coercion if !yagni).
    class Value
      def self.new(*slots, **fields, &block)
        factory(*slots, **fields, &block)
      end

      def self.factory(*slots, **fields, &block)
        if slots.empty? && fields.empty?
          raise ArgumentError.new("missing attribute definition")
        end

        slots_spec, fields_spec = if fields.any?
          raise ArgumentError.new("cannot use slots when field map is supplied") if slots.any?
          [fields.keys, fields]
        else
          [slots, Hash[slots.map { |s| [s, Type::Any]}]]
        end

        validator = Validator.new(fields_spec)

        struct = Struct.new(*slots_spec, keyword_init: true, &block)

        struct.define_method :initialize do |*args, **kwargs|
          attr_values = if args.any?
            raise ArgumentError.new("cannot mix slots and kwargs") if kwargs.any?
            Hash[slots.zip(args)]
          else
            kwargs
          end

          validator.check(attr_values)
          # TODO: type coercion or mapping decision goes here
          super(**attr_values)

          freeze
        end

        struct
      end
    end

    ##
    # Entity with comparison by reference equality. Generates attribute helpers
    # for a declared set of props. Used to replace Hashie::Mash without dragging
    # in a whole new library.
    class Entity
      class << self
        def attribute(name, value_type)
          # define_method("map_#{name}".to_sym) do |input|
          #   value_type.coerce(input)
          # end
          dictionary[name] = value_type
          attr_reader(name)
        end

        def dictionary
          @dictionary ||= Hash.new
        end
      end

      def dictionary
        self.class.dictionary
      end

      def initialize(config)
        dictionary.each_key do |name|
          raise "missing declared attribute #{name}" unless config.key?(name)
        end

        config.each_pair do |key, value|
          raise "#{key} not a declared attribute" unless dictionary.key?(key)

          defined_type = dictionary[key]

          unless value.is_a?(defined_type)
            raise "#{key} accepts #{defined_type} but #{value.class} given"
          end

          instance_variable_set("@#{key}", value)
        end
      end

      def to_h
        dictionary.keys.reduce({}) do |attr_dict, name|
          attr_dict[name] = instance_variable_get("@#{name}")
          attr_dict
        end
      end
    end
  end
end
