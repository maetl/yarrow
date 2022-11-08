module Yarrow
  module Content
    module Expansion
      class Strategy
        include Yarrow::Tools::FrontMatter

        attr_reader :graph

        def initialize(graph)
          @graph = graph
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


        def set_collection_props(node, policy, meta_attrs)
          node.label = :collection
          node.props[:type] = policy.collection
          node.props[:resource] = policy.collection_const.new(meta_attrs)
        end

        def set_item_props(node, policy, meta_attrs)
          node.label = :item
          node.props[:type] = policy.entity
          node.props[:resource] = policy.entity_const.new(meta_attrs)
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
      end
    end
  end
end
