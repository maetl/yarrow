module Yarrow
  module Process
    class StepProcessor
      attr_reader :source

      class << self
        attr_reader :accepted_input, :provided_output

        def accepts(input_const)
          @accepted_input = input_const.to_s
        end

        def provides(output_const)
          @provided_output = output_const.to_s
        end
      end

      def initialize
        @source = nil
      end

      def accepts
        self.class.accepted_input
      end

      def provides
        self.class.provided_output
      end

      def can_accept?(provided)
        accepts == provided
      end

      def process(source)
        # begin
        result = step(source)
        # log.info("<Result source=#{result}>")
        # rescue
        result
      end
    end
  end
end
