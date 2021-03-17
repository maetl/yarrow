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
      def read_content(path)
        case path.extname
        when '.htm', '.md', '.txt'
          read_split_content(path.to_s, symbolize_keys: true)
        # when '.md'
        #   body, data = read_split_content(path.to_s, symbolize_keys: true)
        #   [Kramdown::Document.new(body).to_html, data]
        when '.yml'
          [nil, YAML.load(File.read(path.to_s), symbolize_names: true)]
        when '.json'
          [nil, JSON.parse(File.read(path.to_s))]
        end
      end
    end
  end
end
