module Yarrow
  module Schema
    # class Structure < Struct
    #   def self.inherited(subclass)
    #     unless subclass.name
    #       puts "CLASS"
    #       p caller_locations[3]
    #     else
    #       p subclass.name.downcase.to_sym
    #     end
    #   end
    # end

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

          converted_values = validator.cast(attr_values)

          super(**converted_values)

          freeze
        end

        struct
      end
    end
  end
end
