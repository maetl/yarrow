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

        def accept(type, constructor)
          accepts[type] = constructor
          self
        end

        def should_coerce?(input)
          accepts.key?(input.class)
        end

        def coerce(input)
          constructor = accepts[input.class]
          unit.send(constructor, input)
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
          keys = input.keys.map { |key| key_type.cast(key) }
          values = input.values.map { |value| value_type.cast(value) }
          [keys, values].transpose.to_h
        end
      end
    end
  end
end