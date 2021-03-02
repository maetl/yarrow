module Yarrow
  module Content
    class CollectionExpander
      include Yarrow::Tools::FrontMatter

      def initialize(content_types=nil)
        @content_types = content_types || [
          Yarrow::Content::ContentType.from_name(:pages)
        ]
      end

      def expand(graph)
        @content_types.each do |content_type|
          expand_nested(graph, content_type)
        end
      end

      def expand_nested(graph, content_type)
        type = content_type.collection
        exts = content_type.extensions

        # If match path represents entire content dir, then include the entire
        # content dir instead of scanning from a subfolder matching the name of
        # the collection.
        start_node = if content_type.match_path == "."
          graph.n(:root)
        else
          graph.n(:root).out(name: type.to_s)
        end

        # Extract metadata from given start node
        data = extract_metadata(start_node, type)

        # Collects all nested collections in the subgraph for this content type
        subcollections = {}
        index = nil

        # Define alias for accessing metadata in the loop
        metadata = data

        # Scan and collect all nested directories under the top level source
        start_node.depth_first.each do |node|
          if node.label == :directory
            # Check if this entry has metadata defined at the top level
            if data[:collections]
              item = data[:collections].find { |c| c[:slug] == node.props[:slug] }
              metadata = item if item
            end

            # Create a collection node representing a collection of documents
            index = graph.create_node do |collection_node|
              collection_node.label = :collection
              collection_node.props[:type] = type
              collection_node.props[:name] = node.props[:name]
              collection_node.props[:slug] = node.props[:slug]
              collection_node.props[:title] = metadata[:title]

              # Override default status so that mapped index collections always show
              # up in the resulting document manifest, when they don’t have
              # associated metadata. This is the opposite of how individual pieces
              # of content behave (default to draft status if one isn’t supplied).
              collection_node.props[:status] = if data[:status]
                data[:status]
              else
                "published"
              end

              # TODO: URL generation might need to happen elsewhere
              collection_node.props[:url] = if data[:url]
                data[:url]
              else
                "#{node.props[:path].split('./content').last}/"
              end
            end

            # Add this collection id to the lookup table for edge construction
            subcollections[node.props[:path]] = index

            # Join the collection to its parent
            unless node.props[:slug] == type.to_s || !subcollections.key?(node.props[:entry].parent.to_s)
              graph.create_edge do |edge|
                edge.label = :child
                edge.from = subcollections[node.props[:entry].parent.to_s].id
                edge.to = index.id
              end
            end
          end
        end

        subcollections.each do |path, index|
          # Group files matching the same slug under a common key
          objects = graph.n(path: path).out(:file).all.select do |file|
            file.props[:name].end_with?(*exts)
          end.group_by do |file|
            file.props[:slug]
          end

          build_content_nodes(graph, objects, type, index)
        end
      end

      # Extract collection level configuration/metadata from the root node for
      # this content type.
      def extract_metadata(node, type)
        # TODO: support _index or _slug convention as well
        meta_file = node.out(slug: type.to_s).first

        if meta_file
          # Process metadata and add it to the collection node
          # TODO: pass in content converter object
          # TODO: index/body content by default if extracted from frontmatter
          body, data = process_content(meta_file.props[:entry])
        else
          # Otherwise, assume default collection behaviour
          data = {}
        end

        # Generate a default title if not provided in metadata
        unless data.key?(:title)
          data[:title] = type.to_s.capitalize
        end

        data
      end

      def build_content_nodes(graph, objects, type, parent_index)
        # TODO: this may need to use a strategy that can be overriden
        content_type = ActiveSupport::Inflector.singularize(type).to_sym

        # Process collected content objects and generate entity nodes
        objects.each do |name, sources|
          item_node = graph.create_node do |node|
            # TODO: Rename this to :entry and support similar fields to Atom
            node.label = :item
            node.props[:name] = name
            node.props[:type] = content_type

            meta = {}
            content = ""

            sources.each do |source|
              body, data = process_content(source.props[:entry])
              meta.merge!(data) unless data.nil?
              content << body unless body.nil?
            end

            if meta[:url]
              # If a URL is explicitly proided in metadata then use it
              node.props[:url] = meta[:url]
            elsif meta[:permalink]
              # Support for legacy permalink attribute
              node.props[:url] = meta[:permalink]
            else
              # Default URL generation strategy when no explicit URL is provided
              # TODO: collection nodes need URL generation too
              # TODO: replace this with URL generation strategy
              # TODO: slug vs name - why do some nodes have 2 and some 3 props?
              node.props[:url] = if parent_index.props[:name].to_sym == parent_index.props[:type]
                "/#{parent_index.props[:type]}/#{name}"
              else
                "/#{parent_index.props[:type]}/#{parent_index.props[:slug]}/#{name}"
              end
            end

            # For now, we are storing title, url, etc on the top-level item.
            node.props[:title] = meta[:title]

            # TODO: What belongs on the entity and what belongs on the item?
            entity_props = meta.merge(body: content, name: meta[:id], url: node.props[:url])


            # TODO: consider whether to provide `body` on the item/document or at
            # the custom content type level.
            begin
              content_struct = Object.const_get(ActiveSupport::Inflector.classify(content_type))
            rescue
              require "ostruct"
              content_struct = OpenStruct
            end

            node.props[:entity] = content_struct.new(entity_props)
          end

          # Connect entity with source content
          sources.each do |source|
            graph.create_edge do |edge|
              edge.label = :source
              edge.from = item_node
              edge.to = source.id
            end
          end

          # Connect entity with parent collection
          graph.create_edge do |edge|
            edge.label = :child
            edge.from = parent_index
            edge.to = item_node
          end
        end
      end

      # Workaround for handling meta and content source in multiple files or a single
      # file with front matter.
      def process_content(path)
        case path.extname
        when '.htm', '.md'
          read_split_content(path.to_s, symbolize_keys: true)
        # when '.md'
        #   body, data = read_split_content(path.to_s, symbolize_keys: true)
        #   [Kramdown::Document.new(body).to_html, data]
        when '.yml'
          [nil, YAML.load(File.read(path.to_s), symbolize_names: true)]
        end
      end
    end
  end
end
