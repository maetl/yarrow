module Yarrow
  module Format
    class Yaml < ContentType[".yml", ".yaml"]
      include Methods::Metadata

      def initialize(source)
        @data = YAML.load(source, symbolize_names: true)
      end

      def [](key)
        @data[key]
      end

      def to_h
        @data
      end
    end
  end
end