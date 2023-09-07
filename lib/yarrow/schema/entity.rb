module Yarrow
  module Schema
    # Entity with comparison by reference equality. Generates attribute helpers
    # for a declared set of props. Used to replace Hashie::Mash without dragging
    # in a whole new library.
    class Entity
      class << self
        def attribute(name, value_type)
          dictionary.define_attribute(name, value_type)
          attr_reader(name)
        end

        def dictionary
          @dictionary ||= Dictionary.new({})
        end

        def [](label)
          @label = label
          self
        end

        def inherited(class_name)
          class_type = Yarrow::Schema::Types::Instance.of(class_name).accept(Hash)
          
          if @label
            label = @label
            @label = nil
          else
            label = Yarrow::Symbols.from_const(class_name)
          end

          Yarrow::Schema::Definitions.register(label, class_type)
        end
      end

      def initialize(config)
        converted = dictionary.cast(config)

        converted.each_pair do |key, value|
          # TODO: should we represent this as an attribute set rather than instance vars?
          instance_variable_set("@#{key}", value)
        end
      end

      def to_h
        dictionary.attr_names.reduce({}) do |attr_dict, name|
          value = instance_variable_get("@#{name}")

          attr_dict[name] = if value.respond_to?(:to_h)
            value.to_h
          else
            value
          end

          attr_dict
        end
      end

      def merge(other)
        unless other.is_a?(self.class) || other.is_a?(Hash)
          raise ArgumentError.new("cannot merge entities that are not the same type")
        end

        self.class.new(to_h.merge(other.to_h))
      end

      private

      def dictionary
        self.class.dictionary
      end
    end
  end
end
