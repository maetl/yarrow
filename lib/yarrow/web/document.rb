module Yarrow
  module Web
    class Document
      # This class is somewhat verbose for simplicity and long-term maintainability
      # (having a clear and easy to follow construction, rather than doing anything
      # too clever which has burned this lib in the past).
      def initialize(item, parent, is_index)
        @item = item
        @resource = item.props[:resource]
        @parent = parent
        @is_index = is_index
      end

      def resource
        @resource
      end

      def index
        _index = @item.out_e(:index)
        unless _index.first.nil?
          _index.first.to.props
        else
          nil
        end
      end

      def index_body
        @item.props[:index_body]
      end

      # TODO: manage behaviour with and without current item
      # TODO: link to manifest
      def breadcrumbs
        path = []

        current_parent = @item.in(:collection)

        while !current_parent.first.nil?
          path << current_parent.first.props[:resource]
          current_parent = current_parent.in(:collection)
        end

        path.reverse
      end

      def name
        @resource.name
      end

      def title
        @resource.title
      end

      def type
        @item.props[:type]
      end

      def body
        return @resource.body.to_html if @resource.respond_to?(:body)
        ""
      end

      def url
        if @parent.nil?
          "/"
        else
          segments = [@resource.name]
          current = @parent

          until current.in(:collection).first.nil? do
            segments << current.props[:resource].name
            current = current.in(:collection).first
          end

          suffix = @is_index ? "/" : ""

          "/" + segments.reverse.join("/") + suffix
        end
      end
    end
  end
end
