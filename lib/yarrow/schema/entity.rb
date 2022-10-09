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
      end

      def initialize(config)
        converted = dictionary.cast(config)

        converted.each_pair do |key, value|
          # raise "#{key} not a declared attribute" unless dictionary.key?(key)
          #
          # defined_type = dictionary[key]
          #
          # unless value.is_a?(defined_type)
          #   raise "#{key} accepts #{defined_type} but #{value.class} given"
          # end

          instance_variable_set("@#{key}", value)
        end
      end

      def to_h
        dictionary.attr_names.reduce({}) do |attr_dict, name|
          attr_dict[name] = instance_variable_get("@#{name}")
          attr_dict
        end
      end

      private

      def dictionary
        self.class.dictionary
      end
    end
  end
end
