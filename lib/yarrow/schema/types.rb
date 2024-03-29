module Yarrow
  module Schema
    module Types
      class CastError < TypeError
        def self.instance_of(t, u)
          new("#{t} is not an instance of #{u}")
        end

        def self.kind_of(t, u)
          new("#{t} is not a subclass of #{u}")
        end

        def self.respond_to_any(t, m)
          new("#{t} does not implement any of #{m}")
        end

        def self.respond_to_all(t, m)
          new("#{t} does not implement #{m}")
        end

        def self.union_member(t, s)
          new("#{t} is not a member of union")
        end
      end

      class TypeClass
        def self.of(unit_type)
          new(unit_type)
        end

        attr_reader :unit, :accepts

        def initialize(unit_type=nil)
          @unit = unit_type
          @accepts = {}
        end

        def |(rhs_opt)
          Union.new(self, rhs_opt)
        end

        def accept(type, constructor=:new, options=nil)
          accepts[type] = if options.nil?
            [constructor]
          else
            [constructor, options]
          end

          self
        end

        def should_coerce?(input)
          accepts.key?(input.class)
        end

        # Coerce input into the defined format based on configured
        # accept rules.
        #
        # Will use the unit type’s constructor by default unless
        # an alternative factory method and constructor arguments are
        # provided in the accept rule or passed in via context.
        #
        # Most object coercions use the defaults, but the context
        # and options enable specific customisations, such as passing
        # in an assigned attribute name or the hash key that the input
        # is a value of.
        # 
        # @param [Object] input
        # @param [nil, Hash] context
        #
        # @return [Object] instance of unit type represented by this wrapper
        def coerce(input, context=nil)
          constructor, options = accepts[input.class]

          context_args = if context.nil?
            options.clone
          elsif options.nil?
            context.clone
          else
            options.merge(context)
          end

          if context_args.nil?
            unit.send(constructor, input)
          else
            unit.send(constructor, input, context_args)
          end
        end

        def check_instance_of!(input)
          unless input.instance_of?(unit)
            raise CastError.instance_of(input.class, unit)
          end
        end

        def check_kind_of!(input)
          unless input.kind_of?(unit)
            raise CastError.kind_of(input.class, unit)
          end
        end

        def check_respond_to_any!(input, methods)
          unless methods.any? { |m| input.respond_to?(m) }
            raise CastError.respond_to_any(input.class, methods)
          end
        end

        def check_respond_to_all!(input, methods)
          unless methods.all? { |m| input.respond_to?(m) }
            raise CastError.respond_to_all(input.class, methods)
          end
        end

        def cast(input, context=nil)
          return coerce(input, context) if should_coerce?(input)
          check(input)
        end
      end

      class Any < TypeClass
        def cast(input, context=nil)
          input
        end
      end

      class Instance < TypeClass
        def check(input)
          check_instance_of!(input)
          input
        end
      end

      class Kind < TypeClass
        def check(input)
          check_kind_of!(input)
          input
        end
      end

      class Interface < TypeClass
        def self.any(*args)
          interface_type = new(args)
          interface_type.implementation = :any
          interface_type
        end

        def self.all(*args)
          interface_type = new(args)
          interface_type.implementation = :all
          interface_type
        end

        attr_accessor :implementation

        alias members unit

        def check(input)
          case implementation
          when :any then check_respond_to_any!(input, members)
          when :all then check_respond_to_all!(input, members)
          end

          input
        end
      end

      class List < TypeClass
        def self.any
          # Constraint: must be array instance
          new(Instance.of(Array), Any.new)
        end

        def self.of(wrapped_type)
          new(Instance.of(Array), Instance.of(wrapped_type))
        end

        attr_reader :element_type
        alias container_type unit

        def initialize(unit_type, element_type)
          @element_type = element_type
          super(unit_type)
        end

        def accept_elements(accept_type)
          element_type.accept(accept_type)
          self
        end

        def check(input)
          converted = container_type.cast(input)

          converted.map do |item|
            element_type.cast(item)
          end
        end
      end

      class Map < TypeClass
        #include CompoundType

        def self.of(map_spec)
          if map_spec.is_a?(Hash)
            if map_spec.size == 1
              key_type, value_type = map_spec.first
            else
              raise "map requires a single key => value type"
            end
          else
            key_type = Symbol
            value_type = map_spec
          end

          new(Instance.of(key_type), Instance.of(value_type))
        end

        attr_reader :key_type
        alias value_type unit

        def initialize(key_type, value_type)
          @key_type = key_type
          super(value_type)
        end

        def accept_elements(accept_type, constructor=:new, options=nil)
          value_type.accept(accept_type, constructor, options)
          self
        end

        def check(input)
          result = {}

          input.each_pair do |key, value|
            checked_key = key_type.cast(key)
            checked_value = value_type.cast(value, { key: checked_key })
            result[checked_key] = checked_value
          end

          result
        end
      end

      class Union < TypeClass
        def self.of(*unit_opts)
          instances = unit_opts.map { |unit| Instance.of(unit) }
          new(*instances)
        end

        def initialize(*type_opts)
          @options = type_opts
          super()
        end

        def |(rhs_opt)
          @options << rhs_opt
        end

        def check(input)
          failed_checks = []
          @options.each do |opt|
            begin
              opt.check(input)
            rescue CastError => err
              failed_checks << err
            end
          end

          if failed_checks.size == @options.size
            raise CastError.union_member(input.class, @options.map { |opt| opt.class })
          end

          input
        end
      end
    end
  end
end
