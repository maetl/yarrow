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

        struct.define_method(:merge) do |other|
          unless other.is_a?(self.class)
            raise ArgumentError.new("cannot merge incompatible values")
          end

          kwargs = validator.attr_names.reduce({}) do |data, attr_name|
            current_val = self.send(attr_name)
            other_val = other.send(attr_name)

            # TODO: handle optional types better
            # call out to dictionary?
            # validator.merge(attr_name, current_val, other_val)
            data[attr_name] = if current_val.nil?
              other_val
            elsif other_val.nil?
              current_val
            else
              other_val
            end

            data
          end

          struct.new(**kwargs)
        end

        struct
      end
    end
  end
end
