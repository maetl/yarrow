module Yarrow
  module Tools
    # Synchronous utility functions for working with filesystem content tasks.
    module ContentUtils
      # Pass in a source path and get back a parsed representation of the
      # content if it is in a known text format. Mostly used as a fallback if
      # a custom parser or processing chain is not configured for a content
      # type.
      #
      # Supported formats:
      # - HTML template and document partials
      # - Markdown documents
      # - YAML documents
      # - JSON (untested)
      #
      # Works around meta and content source in multiple files or a single
      # file with front matter.
      def read_yfm(name)
        path = if name.is_a?(Pathname)
          name
        else
          Pathname.new(name)
        end

        text = File.read(path, :encoding => 'utf-8')

        case path.extname
        when '.htm', '.md', '.txt', '.yfm'
          extract_yfm(text, symbolize_keys: true)
        # when '.md'
        #   body, data = read_split_content(path.to_s, symbolize_keys: true)
        #   [Kramdown::Document.new(body).to_html, data]
        when '.yml'
          [nil, YAML.load(File.read(path.to_s), symbolize_names: true)]
        when '.json'
          [nil, JSON.parse(File.read(path.to_s))]
        end
      end

      def extract_yfm(text, options={})
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

      def write_yfm(name, text, meta)
        # Symbolized keys are better to deal with when manipulating data in
        # Ruby but are an interop nightmare when serialized so here we do a
        # round-trip through JSON encoding to ensure all keys are string
        # encoded before dumping them to the front matter format.
        File.write(name, [YAML.dump(meta.to_json), "---", text].join("\n"))
      end
    end
  end
end
