module Yarrow
  module Process
    class Pipeline
      def initialize(source_type)
        @pipes = []
        @source_type = source_type.to_s.to_sym
      end

      def current_pipe_provides
        if @pipes.any?
          @pipes.last.provides
        else
          @source_type
        end
      end

      def can_connect?
        if @pipes.any?
          @pipes.last.can_connect?
        else
          true
        end
      end

      def connect(pipe)
        #unless pipe.is_a?()
        # connect must accept a pipe instance

        unless can_connect?
          raise ArgumentError.new("Cannot connect after split into child pipelines")
        end

        if pipe.can_accept?(current_pipe_provides)
          @pipes << pipe
        else
          raise ArgumentError.new(
            "`#{pipe.class}` accepts `#{pipe.accepts}` but was provided `#{current_pipe_provides}`"
          )
        end
      end

      # Splits the pipeline into two separate child pipelines.
      def split(&block)
        first_child = self.class.new(current_pipe_provides)
        last_child = self.class.new(current_pipe_provides)

        connect(Manifold[current_pipe_provides].new(first_child, last_child))

        block.call(first_child, last_child)
      end

      def manifold(outlet_count, &block)
        pipelines = []
        outlet_count.times do
          pipelines << self.class.new(current_pipe_provides)
        end

        connect(Manifold[current_pipe_provides].new(*pipelines))

        block.call(pipelines)
      end

      def tee(&block)
        pipeline = self.class.new(current_pipe_provides)

        connect(Junction[current_pipe_provides, current_pipe_provides].new(pipeline))

        block.call(pipeline)
      end

      def run(source)
        buffer = source
        children = []

        @pipes.each do |pipe|
          result = pipe.run(buffer)
          buffer = result.value
          children.concat(result.children)
        end

        Result.new(buffer, children)
      end
    end
  end
end
