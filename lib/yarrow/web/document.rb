module Yarrow
  module Web
    class Document
      # This class is somewhat verbose for simplicity and long-term maintainability
      # (having a clear and easy to follow construction, rather than doing anything
      # too clever which has burned this lib in the past).
      def initialize(item, parent, url_strategy)
        @item = item
        @parent = parent
        @url_strategy = url_strategy
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
        case @url_strategy
        when :mirror_source
          unless @parent.nil?
            "/#{@parent.props[:name]}/#{name}"
          else
            "/#{name}/"
          end
        end
      end
    end
  end
end
