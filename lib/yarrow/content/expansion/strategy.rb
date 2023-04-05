module Yarrow
  module Content
    module Expansion
      class Strategy
        include Yarrow::Tools::FrontMatter

        attr_reader :graph

        def initialize(graph)
          @graph = graph
          @subcollections = {}
          @entity_links = []
          @index_links = []
          @index = nil
        end

        # Expand a directory to a collection node representing a collection of entities
        def expand_directory(policy, node)
          index = graph.create_node do |collection_node|

            collection_attrs = {
              name: node.props[:name],
              title: node.props[:name].capitalize,
              body: ""
            }

            populate_collection(collection_node, policy, collection_attrs)
          end

          # Add this collection id to the lookup table for edge construction
          @subcollections[node.props[:path]] = index

          # Join the collection to its parent
          unless node.props[:slug] == policy.collection.to_s || !@subcollections.key?(node.props[:entry].parent.to_s)
            graph.create_edge do |edge|
              edge.label = :child
              edge.from = @subcollections[node.props[:entry].parent.to_s].id
              edge.to = index.id
            end
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

        def populate_collection(node, policy, meta_attrs)
          node.label = :collection
          node.props[:type] = policy.collection
          node.props[:resource] = policy.collection_const.new(meta_attrs)
        end

        def populate_entity(node, policy, meta_attrs)
          node.label = :item
          node.props[:type] = policy.entity
          node.props[:resource] = policy.entity_const.new(meta_attrs)
        end

        def merge_collection_index(node, policy, meta_attrs)
          props = { resource: node.props[:resource].merge(meta_attrs) }
          node.merge_props(props)
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
          # TODO: Raise error if unsupported extname reaches here
        end

        def connect_expanded_entities
          # Once all files and directories have been expanded, connect all the child
          # edges between collections and entities
          @entity_links.each do |entity_link|
            graph.create_edge do |edge|
              edge.label = :child
              edge.from = entity_link[:parent_id].id
              edge.to = entity_link[:child_id].id
            end
          end

          # Merge index page body and metadata with their parent collections
          @index_links.each do |index_link|
            merge_collection_index(index_link[:parent_id], policy, index_link[:index_attrs])
          end
        end
      end
    end
  end
end
