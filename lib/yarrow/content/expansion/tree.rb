module Yarrow
  module Content
    module Expansion
      class Tree < Strategy
        def expand(policy)
          #p graph.n(:root).out(:directory).to_a.count
          #policy.match()

          #p graph.n(:root).out(:directory).first.props[:name]
          type = policy.container

          # If match path represents entire content dir, then include the entire
          # content dir instead of scanning from a subfolder matching the name of
          # the collection.
          #start_node = if policy.match_path == "."
          start_node = if true
            # TODO: match against source_dir
            graph.n(:root).out(:directory)
          else
            graph.n(:root).out(name: policy.container.to_s)
          end

          # Extract metadata from given start node
          collection_metadata = extract_metadata(start_node, policy.container)

          # Collect all nested collections in the subgraph for this content type
          subcollections = {}
          entity_links = []
          index = nil

          # Scan and collect all nested files from the root
          start_node.depth_first.each do |node|
            if node.label == :directory
              # Create a collection node representing a collection of documents
              index = graph.create_node do |collection_node|

                collection_attrs = {
                  name: node.props[:name],
                  title: node.props[:name].capitalize
                }

                populate_collection(collection_node, policy, collection_attrs)
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
            elsif node.label == :file
              body, meta = process_content(node.props[:entry])

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
              entity_links << {
                parent_id: subcollections[node.props[:entry].parent.to_s].id,
                child_id: entity.id
              }
            end
          end

          # Once all files and directories have been expanded, connect all the child
          # edges between collections and entities
          entity_links.each do |entity_link|
            graph.create_edge do |edge|
              edge.label = :child
              edge.from = entity_link[:parent_id]
              edge.to = entity_link[:child_id]
            end
          end
        end
      end
    end
  end
end
