module Yarrow
  module Format
    class Contents
      attr_reader :document, :metadata

      def initialize(document, metadata)
        @document = document
        @metadata = metadata
      end
    end

    Registry = {}

    class ContentType
      def self.[](*extensions)
        @@extensions_cache = extensions
        self
      end

      def self.inherited(media_type)
        return if @@extensions_cache.nil?

        @@extensions_cache.each do |extname|
          Registry[extname] = media_type
        end

        @@extensions_cache = nil
      end

      def initialize(source)
        @source = source
      end

      def to_s
        @source
      end
    end

    # Pass in a source path and get back a parsed representation of the
    # content if it is in a known text format. Mostly used as a fallback if
    # a custom parser or processing chain is not configured for a content
    # type.
    def self.read(name)
      path = if name.is_a?(Pathname)
        name
      else
        Pathname.new(name)
      end

      # case path.extname
      # when '.htm', '.md', '.txt', '.yfm'
      #   Markdown.read(path)
      # when '.yml'
      #   [nil, YAML.load(File.read(path.to_s), symbolize_names: true)]
      # when '.json'
      #   [nil, JSON.parse(File.read(path.to_s))]
      # end
    
      unless Registry.key?(path.extname)
        raise "Unsupported format: #{path.extname} (#{path})"
      end
        
      Registry[path.extname].read(path)
    end
  end
end

require_relative "format/methods/front_matter"
require_relative "format/methods/metadata"
require_relative "format/markdown"
require_relative "format/yaml"
