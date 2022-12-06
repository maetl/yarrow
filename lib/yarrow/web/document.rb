  module Yarrow
  module Web
    class BaseDocument
      def resource
        @resource
      end

      def type
        @type
      end

      # TODO: confirm this can be deleted
      def index
        _index = @item.out_e(:index)
        unless _index.first.nil?
          _index.first.to.props
        else
          nil
        end
      end

      # TODO: confirm this can be deleted
      def index_body
        @item.props[:index_body]
      end

      # TODO: manage behaviour with and without current item
      # TODO: link to manifest
      #
      # TODO: replace @item and @collection with @node internally and in class interface
      def breadcrumbs
        path = []

        current_parent = @node.in(:collection)

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

    class IndexDocument < BaseDocument
      # Represents the index document of a collection. This contains
      # a reference to the individual items in the collection as well as
      # any document content itself.
      def initialize(collection, item=nil, is_index=false)
        @collection = collection
        @item = item
        # The parent node of the collection is the first incoming node link
        @parent = collection.in(:collection).first
        @is_index = is_index

        template_map = collection.out_e(:child).to.all.inject([]) do |result, node|
          result << Document.new(node, false)
        end

        instance_variable_set("@children", template_map)
        define_singleton_method(:children){ template_map }

        if @item.nil?
          @resource = collection.props[:resource]
          @type = collection.props[:type]
          @node = collection
        else
          @resource = item.props[:resource]
          @type = item.props[:type]
          @node = item
        end

        instance_variable_set("@#{@type}", @resource)
        define_singleton_method(@type){ @resource }
      end
    end

    class Document < BaseDocument
      # This class is somewhat verbose for simplicity and long-term maintainability
      # (having a clear and easy to follow construction, rather than doing anything
      # too clever which has burned this lib in the past).
      def initialize(item, is_index)
        @item = item
        @type = item.props[:type]
        @parent = item.in(:collection).first
        @node = item
        @is_index = is_index
        @resource = item.props[:resource]
        instance_variable_set("@#{item.props[:type]}", @resource)
        define_singleton_method(item.props[:type]){ @resource }
      end
    end
  end
end
