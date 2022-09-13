module Yarrow
  module Content
    # Collects a digraph of all directories and files underneath the given input
    # directory.
    class Source
      def self.collect(input_dir)
        Mementus::Graph.new(is_mutable: true) do
          root = create_node do |root|
            root.label = :root
          end

          root_dir_entry = Pathname.new(input_dir)

          root_dir = create_node do |dir|
            dir.label = :directory
            dir.props = {
              name: root_dir_entry.basename.to_s,
              path: root_dir_entry.to_s,
              entry: root_dir_entry
            }
          end

          create_edge do |child|
            child.label = :child
            child.from = root.id
            child.to = root_dir.id
          end

          directories = {
            root_dir_entry.to_s => root_dir.id
          }

          Pathname.glob("#{input_dir}/**/**").each do |entry|
            if entry.directory?
              content_node = create_node do |dir|
                dir.label = :directory
                # dir.props[:name] = entry.basename.to_s
                # dir.props[:slug] = entry.basename.to_s
                # dir.props[:path] = entry.to_s
                # dir.props[:entry] = entry
                dir.props = {
                  name: entry.basename.to_s,
                  path: entry.to_s,
                  entry: entry
                }
              end

              directories[entry.to_s] = content_node.id
            else
              content_node = create_node do |file|
                file.label = :file
                # file.props[:name] = entry.basename.to_s
                # file.props[:slug] = entry.basename.sub_ext('').to_s
                # file.props[:path] = entry.to_s
                # file.props[:entry] = entry

                file.props = {
                  name: entry.basename.to_s,
                  ext: entry.extname.to_s,
                  path: entry.to_s,
                  entry: entry
                }
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
