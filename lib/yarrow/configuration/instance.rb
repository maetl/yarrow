module Yarrow
  module Configuration
    class Instance
      def self.from_doc(config_doc)
        content = Content.defaults
        output = Output.defaults

        config_doc.nodes.each do |node|
          case node.name.to_sym
          when :content then content = Content.from_node(node)
          when :output then output = Output.from_node(node)
          else
            raise "Invalid config section: #{node.name}"
          end
        end
        
        new(content, output)
      end

      attr_reader :content, :output

      def initialize(content)
        @content = content
        @output = Output.new
      end
    end
  end
end