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
      # @param slots [Array<Symbol>, <Hash>] defines the slots in the schema to validate against
      def initialize(slots)
        @keys = slots.reduce({}) do |keys, slot|
          if slot.is_a?(Array)
            keys[slot[0]] = slot[1]
          else
            keys[slot.to_sym] = Type::Any
          end

          keys
        end
      end

      def check(fields)
        raise "wrong number of args" unless fields.keys.length == @keys.keys.length

        fields.keys.each do |key|
          raise "key does not exist" unless @keys.key?(key)
        end
      end
    end

    ##
    # Value object (with comparison by value equality). This just chucks back a
    # Ruby struct but wraps the constructor with method advice that handles
    # validation (and eventually type coercion if !yagni).
    class Value
      def self.new(*slots, &block)
        factory(*slots, &block)
      end

      def self.factory(*slots, &block)
        validator = Validator.new(slots)

        struct = Struct.new(*slots, keyword_init: true, &block)

        struct.define_method :initialize do |kwargs|
          validator.check(kwargs)
          # TODO: type coercion or mapping decision goes here
          super(**kwargs)
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
          raise "missing declared attribute #{name}" unless dictionary.key?(name)
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
    end

    def to_h
      dictionary.keys.reduce({}) do |h, name|
        h[name] = instance_variable_get("@#{name}")
      end
    end
  end
end
