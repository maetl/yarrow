module Yarrow
  module Web
    class Document
      # This class is somewhat verbose for simplicity and long-term maintainability
      # (having a clear and easy to follow construction, rather than doing anything
      # too clever which has burned this lib in the past).
      def initialize(item, parent, is_index)
        @item = item
        @parent = parent
        @is_index = is_index
      end

      def name
        @item.props[:name]
      end

      def title
        @item.props[:title]
      end

      def type
        @item.props[:type]
      end

      def url
        if @parent.nil?
          "/"
        else
          segments = [@item.props[:name]]
          current = @parent

          until current.in(:collection).first.nil? do
            segments << current.props[:name]
            current = current.in(:collection).first
          end

          "/" + segments.reverse.join("/")
        end
      end
    end
  end
end
