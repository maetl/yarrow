module Yarrow
  module Process
    class Workflow
      def initialize(source_type)
        @pipeline = []
        @source_type = source_type.to_s
        @callbacks = {
          complete: nil,
          error: nil
        }
      end

      def provides_type
        if @pipeline.any?
          @pipeline.last.provides
        else
          @source_type
        end
      end

      def can_connect?
        if @pipeline.any?
          @pipeline.last.can_connect?
        else
          true
        end
      end

      def connect(processor)
        unless can_connect?
          raise ArgumentError.new("Cannot connect tasks at this level after workflow is split")
        end

        if processor.can_accept?(provides_type)
          @pipeline << processor
        else
          raise ArgumentError.new(
            "`#{processor.class}` accepts `#{processor.accepts}` but was provided `#{provides_type}`"
          )
        end
      end

      def split(&block)
        conduit1 = self.class.new(provides_type)
        conduit2 = self.class.new(provides_type)

        connect(Task[provides_type].new(conduit1, conduit2))

        block.call(conduit1, conduit2)
      end

      def manifold(outlet_count, &block)
        conduits = []
        outlet_count.times do
          conduits << self.class.new(provides_type)
        end

        connect(Task[provides_type].new(*conduits))

        block.call(conduits)
      end

      def tee(&block)
        conduit = self.class.new(provides_type)

        block.call(conduit)

        b = Task[provides_type, provides_type].new(conduit)

        p b

        connect(b)
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

        @pipeline.each do |processor|
          result = processor.process(result)
        end

        @callbacks[:complete].call(result) if @callbacks[:complete]
      end
    end
  end
end
