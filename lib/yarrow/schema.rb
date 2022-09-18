require "delegate"

module Yarrow
  module Schema
    module Type
      class Raw
        class << self
          def [](primitive)
            @primitive = primitive
          end

          def new(input)
            input
          end
        end
      end

      class Any
      end
      # class Attribute
      #   class << self
      #     def accepts(attr_type)
      #       @accepts = attr_type
      #     end
      #   end
      #
      #   attr_accessor :value
      #   alias_method :__getobj__, :value
      #
      #   def initialize(value)
      #     raise "Invalid type" unless @accepts.is_a?(value.class)
      #     @value = value
      #   end
      # end
      #
      # class Text < Attribute
      #   accepts String
      # end
    end
  end
end
