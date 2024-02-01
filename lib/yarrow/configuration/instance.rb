module Yarrow
  module Configuration
    class Instance
      attr_reader :content

      def self.from_doc(config_doc)
        content = Content.defaults

        config_doc.nodes.each do |node|
          case node.name.to_sym
          when :content then content = Content.from_node(node)
          else
            raise "Invalid config section: #{node.name}"
          end
        end
        
        new(content)
      end

      def initialize(content)
        @content = content
      end
    end
  end
end