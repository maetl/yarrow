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

        attr_reader :unit
  
        def initialize(unit_type=nil)
          @unit = unit_type
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

        def cast(input); end
      end
  
      class Any < TypeClass
        def cast(input)
          input
        end
      end
  
      class Instance < TypeClass
        def cast(input)
          check_instance_of!(input)
          input
        end
      end
  
      class Kind < TypeClass
        def cast(input)
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

        def cast(input)
          case implementation
          when :any then check_respond_to_any!(input, members)
          when :all then check_respond_to_all!(input, members)
          end
          
          input
        end
      end

      class Union
      end
    end
  end
end