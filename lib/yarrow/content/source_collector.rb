module Yarrow
  module Content
    # Collects a digraph of all directories and files underneath the given input
    # directory.
    class SourceCollector
      def self.collect(input_dir)
        Mementus::Graph.new(is_mutable: true) do
          root = create_node do |root|
            root.label = :root
          end

          directories = {
            Pathname.new(input_dir).to_s => root.id
          }

          Pathname.glob("#{input_dir}/**/**").each do |entry|
            if entry.directory?
              content_node = create_node do |dir|
                dir.label = :directory
                dir.props[:name] = entry.basename.to_s
                dir.props[:slug] = entry.basename.to_s
                dir.props[:path] = entry.to_s
                dir.props[:entry] = entry
              end

              directories[entry.to_s] = content_node.id
            else
              content_node = create_node do |file|
                file.label = :file
                file.props[:name] = entry.basename.to_s
                file.props[:slug] = entry.basename.sub_ext('').to_s
                file.props[:path] = entry.to_s
                file.props[:entry] = entry
              end
            end

            if directories.key?(entry.dirname.to_s)
              create_edge do |edge|
                edge.label = :child
                edge.from = directories[entry.dirname.to_s]
                edge.to = content_node
              end
            end
          end
        end
      end
    end
  end
end
