module Yarrow
  module Content
    class Source
      attr_reader :input_dir

      def initialize(config)
        @input_dir = config[:input_dir]
      end
    end
  end
end
