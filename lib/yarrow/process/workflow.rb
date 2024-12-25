module Yarrow
  module Process
    class Workflow
      def initialize(source_type)
        @processors = []
        @source_type = source_type.to_s
        @callbacks = {
          complete: nil,
          error: nil
        }
      end

      def provided_input
        if @processors.any?
          @processors.last.provides
        else
          @source_type
        end
      end

      def can_connect?
        if @processors.any?
          @processors.last.can_connect?
        else
          true
        end
      end

      def connect(processor)
        unless can_connect?
          raise ArgumentError.new("Cannot connect tasks at this level after workflow is split")
        end

        if processor.can_accept?(provided_input)
          @processors << processor
        else
          raise ArgumentError.new(
            "`#{processor.class}` accepts `#{processor.accepts}` but was provided `#{provided_input}`"
          )
        end
      end

      def split(&block)
        conduit1 = self.class.new(provided_input)
        conduit2 = self.class.new(provided_input)

        connect(BranchingTask[provided_input].new(conduit1, conduit2))

        block.call(conduit1, conduit2)
      end

      def manifold(outlet_count, &block)
        conduits = []
        outlet_count.times do
          conduits << self.class.new(provided_input)
        end

        connect(BranchingTask[provided_input].new(*conduits))

        block.call(conduits)
      end

      def tee(&block)

      end

      def on_error(&block)
        @callbacks[:error] = block.to_proc
      end

      def on_complete(&block)
        @callbacks[:complete] = block.to_proc
      end

      def run(source)
        if source.class.to_s != @source_type
          raise ArgumentError.new("invalid type passed to workflow.process")
        end

        result = source

        @processors.each do |processor|
          result = processor.process(result)
        end

        @callbacks[:complete].call(result) if @callbacks[:complete]
      end
    end
  end
end
