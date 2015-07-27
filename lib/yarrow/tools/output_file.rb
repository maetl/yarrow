module Yarrow
  module Tools
    # TODO: consider renaming this to OutputDocument.
    class OutputFile
      include Yarrow::Configurable

      WRITE_MODE = 'w+:UTF-8'.freeze

      # @return [String] Basename reflecting the server convention (usually: index.html)
      def index_name
        @index_name ||= config.index_name || 'index.html'
      end

      # @return [String] Docroot of the output target
      def docroot
        @docroot ||= config.output_dir || 'public'
      end

      # Write an output file to the specified path under the docroot.
      #
      # @param path [String]
      # @param content [String]
      def write(path, content)
        # If the target path is a directory,
        # generate a default index filename.
        if path[path.length-1] == '/'
          path = "#{path}#{index_name}"
        end

        target_path = Pathname.new("#{docroot}#{path}")

        FileUtils.mkdir_p(target_path.dirname)

        File.open(target_path.to_s, WRITE_MODE) do |file|
          file.puts(content)
        end
      end
    end
  end
end
