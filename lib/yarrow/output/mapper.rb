module Yarrow
  module Output
    class Mapper

      def initialize(config)
        @config = config
      end

      def object_map
        @config.output.object_map
      end

      def template_map
        @config.output.template_map
      end

      def model

      end

    end
  end
end