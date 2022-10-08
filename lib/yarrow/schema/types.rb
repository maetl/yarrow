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
      end
  
      class TypeClass
        attr_reader :unit
  
        def initialize(unit=nil)
          @unit = unit
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

        def check_respond_to!(input)

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
  
      class Kind
        def cast(input)
          check_kind_of!(input)
          input
        end
      end
  
      class Interface
  
      end
  
      class Optional
  
      end
  
      class Constrained
  
      end
    end
  end
end