module Yarrow
  module Configuration
    class Output
      DEFAULT_DIRECTORY = "dist"

      def self.defaults
        new({ directory: DEFAULT_DIRECTORY })
      end

      def self.from_node(output_node)
        props = { targets: [] }
        output_node.children.each do |target_node|
          # TODO: Need to construct target objects and pass them in as props.
          #
          # eg:
          #
          # ```
          # output {
          #  templates directory="tpl"
          #  web directory="www"
          # }
          # ```
          #
          # `web directory="www"` and `web "www"` should be treated
          # the same in config reader.
        end
      end

      attr_reader :directory

      def initialize(props)
        @directory = Pathname.new(props[:directory] || DEFAULT_DIRECTORY).expand_path
      end
    end
  end
end
