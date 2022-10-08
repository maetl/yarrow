module Yarrow
  module Schema
    # Value object (with comparison by value equality). This just chucks back a
    # Ruby struct but wraps the constructor with method advice that handles
    # type checking and conversion.
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
          [slots, Hash[slots.map { |s| [s, :any]}]]
        end

        validator = Dictionary.new(fields_spec)

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
  end
end
