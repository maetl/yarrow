module Yarrow
  module Content
    class TreeExpansion < ExpansionStrategy
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
        item_links = []
        index = nil

        # Scan and collect all nested files from the root
        start_node.depth_first.each do |node|
          if node.label == :directory
            # Create a collection node representing a collection of documents
            index = graph.create_node do |collection_node|
              collection_node.label = :collection
              collection_node.props[:type] = policy.container
              collection_node.props[:name] = node.props[:name]

              # TODO: title needs to be defined from metadata
              collection_node.props[:title] = node.props[:name].capitalize
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

            # Create an item node representing a file mapped to a unique content object
            item = graph.create_node do |item_node|
              item_node.label = :item
              item_node.props[:type] = policy.record
              item_node.props[:name] = node.props[:entry].basename(node.props[:entry].extname).to_s
              item_node.props[:body] = body if body
              item_node.props[:title] = meta[:title] if meta
              # TODO: better handling of metadata on node props
            end

            # We may not have an expanded node for the parent collection if this is a
            # preorder traversal so save it for later
            item_links << {
              parent_path: node.props[:entry].parent.to_s,
              item_id: item.id
            }
          end
        end

        # Once all files and directories have been expanded, connect all the child
        # edges between collections and items
        item_links.each do |item_link|
          graph.create_edge do |edge|
            edge.label = :child
            edge.from = subcollections[item_link[:parent_path]].id
            edge.to = item_link[:item_id]
          end
        end
      end
    end
  end
end
