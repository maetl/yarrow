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

        def coerce(input)
          constructor, options = accepts[input.class]

          # TODO: should we clone all input so copy is stored rather than ref?
          if options.nil?
            unit.send(constructor, input)
          else
            unit.send(constructor, input, options.clone)
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

        def cast(input)
          return coerce(input) if should_coerce?(input)
          check(input)
        end
      end

      class Any < TypeClass
        def cast(input)
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

      module CompoundType
        def instance(unit_type)
          @unit = Instance.of(unit_type)
          self
        end

        def kind(unit_type)
          @unit = Kind.of(unit_type)
          self
        end

        def interface(*args)
          @unit = Interface.of(args)
          self
        end
      end

      class List < TypeClass
        include CompoundType

        def self.of(unit_type)
          new(Instance.of(unit_type))
        end

        def cast(input)
          input.map do |item|
            unit.cast(item)
          end
        end
      end

      class Map < TypeClass
        include CompoundType

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

        def check(input)
          keys = input.keys.map do |key|
            key_type.cast(key)
          end
          values = input.values.map do |value|
            value_type.cast(value)
          end

          [keys, values].transpose.to_h
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
