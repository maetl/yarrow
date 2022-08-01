module Yarrow
  module Content
    class CollectionExpander
      include Yarrow::Tools::FrontMatter

      # If a list of object types is not provided, a default `pages` type is
      # created.
      def initialize(object_types=nil)
        @object_types = object_types || [
          Yarrow::Content::ObjectType.from_name(:pages)
        ]
      end

      def expand(graph)
        @object_types.each do |object_type|
          expand_nested(graph, object_type)
        end
      end

      def expand_nested(graph, content_type)
        strategy = TreeExpansion.new(graph)
        strategy.expand(content_type)
      end

      def expand_nested_legacy(graph, content_type)
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

        # If there are no subcollections then we need to look at the start node
        # TODO: test to verify if this could be used in all cases, not just
        # the situation where there are subfolders to be mapped.
        if subcollections.empty?
          # Collect files that match the content type extension and group them
          # under a common key for each slug (this is so we can merge multiple
          # files with the same name together into a single content type, a
          # specific pattern found in some legacy content folders).
          #
          # Ideally, this code should be deleted once we have a clean workflow
          # and can experiment with decoupling different strategies for
          # expansion/enrichment of content objects.
          objects = start_node.out(:file).all.select do |file|
            file.props[:name].end_with?(*exts)
          end.group_by do |file|
            file.props[:slug]
          end

          # This is a massive hack to deal with situations where we don’t
          # recurse down the list of directories. The best way to clean it up
          # will be to document the different supported mapping formats and
          # URL generation strategies and break these up into separate
          # traversal objects for each particular style of content organisation.
          if index.nil?
            index = graph.create_node do |collection_node|
              collection_node.label = :collection
              collection_node.props[:type] = type
              collection_node.props[:name] = type
              collection_node.props[:slug] = type.to_s
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
                "/#{type}/"
              end
            end
          end

          build_content_nodes(graph, objects, type, index)
        end

        # Go through each subcollection and expand content nodes step by step.
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

      def build_content_nodes(graph, objects, type, parent_index)
        # TODO: this may need to use a strategy that can be overriden
        content_type = Yarrow::Symbols.to_singular(type)

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
              content_struct = Yarrow::Symbols.to_const(content_type)
            rescue
              # No immutable struct found: fall back to slower dynamically typed open struct
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
    end
  end
end
