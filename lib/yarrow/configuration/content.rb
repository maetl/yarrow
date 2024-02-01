module Yarrow
  module Configuration
    class Content
      DEFAULT_DIRECTORY = "."
      DEFAULT_MODULE = ""

      def self.defaults
        new({ directory: DEFAULT_DIRECTORY, module: DEFAULT_MODULE }, {})
      end
      
      def self.from_node(content_node)
        props = {}
        expansions = [ExpansionPolicy.defaults]
        content_node.children.each do |prop_node|
          case prop_node.name.to_sym
          when :directory then props[:directory] = prop_node.arguments.first.value
          when :module then props[:module] = prop_node.arguments.first.value
          when :expansions
            expansions = prop_node.children.map do |expansion_node|
              ExpansionPolicy.from_node(expansion_node)
            end
          else
            raise "Invalid content prop #{prop_node.name}"
          end
        end
        Content.new(props, expansions)
      end

      attr_reader :directory, :module, :expansions

      def initialize(props, expansions)
        @directory = props[:directory] || DEFAULT_DIRECTORY
        @module = props[:module] || DEFAULT_MODULE
        @expansions = expansions
      end
    end
  end
end