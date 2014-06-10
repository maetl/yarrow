module Yarrow
  module Tools
    module FrontMatter

      def read_split_content(path)
        extract_split_content(File.read(path))
      end

      def extract_split_content(text)
        pattern = /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
        if text =~ pattern
          content = text.sub(pattern, "")

          begin
            meta = YAML.load($1)
            return [content, meta]
          rescue => e
            puts "Parsing Exception: #{e.message}"
          end

        end

        [text, nil]
      end

    end
  end
end
