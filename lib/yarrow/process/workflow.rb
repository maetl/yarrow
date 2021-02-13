module Yarrow
  module Process
    class Workflow
      def initialize(input)
        @input = input
        @processors = []
      end

      def connect(processor)
        provided_input = if @processors.any?
          @processors.last.provides
        else
          @input.class.to_s
        end

        if processor.can_accept?(provided_input)
          @processors << processor
        else
          raise ArgumentError.new(
            "`#{processor.class}` accepts `#{processor.accepts}` but was connected to `#{provided_input}`"
          )
        end
      end

      def process(&block)
        result = @input

        @processors.each do |processor|
          result = processor.process(result)
        end

        block.call(result)
      end
    end
  end
end
