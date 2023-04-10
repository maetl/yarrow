module Yarrow
  module Format
    class Markdown < ContentType[".md", ".markdown"]
      include Methods::FrontMatter

      def initialize(source)
        @source = source.to_s
        @document = Kramdown::Document.new(@source)
      end

      def to_s
        @source
      end
  
      def to_dom
        @document.root
      end
  
      def to_html
        @document.to_html
      end
  
      def links
        @links ||= select_links
      end
  
      def title
        @title ||= select_title
      end
  
      private
  
      def select_links
        stack = to_dom.children
        hrefs = [] # TODO: distinguish between internal and external
  
        while !stack.empty?
          next_el = stack.pop
  
          if next_el.type == :a
            hrefs << next_el.attr["href"]
          else
            stack.concat(next_el.children) if next_el.children
          end
        end
  
        hrefs.reverse
      end
  
      def select_title
        stack = to_dom.children
  
        while !stack.empty?
          next_el = stack.pop
  
          if next_el.type == :header and next_el.options[:level] == 1
            return next_el.options[:raw_text]
          else
            stack.concat(next_el.children) if next_el.children
          end
        end
  
        nil
      end
    end
  end
end