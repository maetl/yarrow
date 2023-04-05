module Yarrow
  module Content
    module Expansion
      class Tree < Strategy
        def expand(policy)
          # If match path represents entire content dir, then include the entire
          # content dir instead of scanning from a subfolder matching the name of
          # the collection.
          #start_node = if policy.match_path == "."
          start_node = if policy.match_path == "."
            # TODO: match against source_dir
            graph.n(:root).out(:directory)
          else
            graph.n(name: policy.match_path)
          end

          # Collect all nested collections in the subgraph for this content type
          @subcollections = {}
          @entity_links = []
          @index_links = []
          @index = nil

          # Scan and collect all nested files from the root
          start_node.depth_first.each do |node|
            if node.label == :directory
              expand_directory(policy, node)
            elsif node.label == :file
              expand_file_by_extension(policy, node)
            end
          end

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

        def expand_file_by_basename(policy, node)
          body, meta = process_content(node.props[:entry])
          meta = {} if !meta


        end

        def expand_file_by_extension(policy, node)
          body, meta = process_content(node.props[:entry])
          meta = {} if !meta

          # TODO: document mapping convention for index pages and collection metadata
          # TODO: underscore _index pattern?
          bare_basename = node.props[:entry].basename(node.props[:entry].extname)
          if bare_basename.to_s == "index"
            @index_links << {
              parent_id: @subcollections[node.props[:entry].parent.to_s],
              index_attrs: meta.merge({ body: body})
            }
          else
            # Create an entity node representing a file mapped to a unique content object
            entity = graph.create_node do |entity_node|

              entity_slug = node.props[:entry].basename(node.props[:entry].extname).to_s

              entity_attrs = {
                name: entity_slug,
                title: entity_slug.gsub("-", " ").capitalize,
                body: body
              }

              populate_entity(entity_node, policy, entity_attrs.merge(meta || {}))
            end

            # We may not have an expanded node for the parent collection if this is a
            # preorder traversal so save it for later
            @entity_links << {
              parent_id: @subcollections[node.props[:entry].parent.to_s],
              child_id: entity
            }
          end
        end
      end
    end
  end
end
