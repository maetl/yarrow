module Yarrow
  module Tools
    module FrontMatter

      def read_split_content(path, options={})
        extract_split_content(File.read(path, :encoding => 'utf-8'), options)
      end

      def extract_split_content(text, options={})
        pattern = /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
        if text =~ pattern
          content = text.sub(pattern, "")

          begin
            if options.key?(:symbolize_keys)
              meta = YAML.load($1, symbolize_names: true)
            else
              meta = YAML.load($1)
            end
            return [content, meta]
          rescue Psych::SyntaxError => error
            if defined? ::Logger
              # todo: application wide logger
              #logger = ::Logger.new(STDOUT)
              #logger.error "#{error.message}"
            end
            return [content, nil]
          end
        end

        [text, nil]
      end
    end
  end
end
