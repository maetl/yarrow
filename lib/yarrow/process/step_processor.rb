module Yarrow
  module Process
    class Result
      attr_reader :value, :children

      def initialize(value, children=[])
        @value = value
        @children = children
      end
    end

    # Base class for pipeline conduits that support type checking
    # accepted input and provided output when connected in a sequence.
    class Pipe
      class << self
        attr_reader :accepts, :provides
    
        # Define the accepted input type for this pipe.
        def accept(input_const)
          @accepts = input_const.to_s.to_sym
        end
    
        # Define the provided output type for this pipe.
        def provide(output_const)
          @provides = nil unless @provides
          @provides = output_const.to_s.to_sym
        end
    
        # Factory method shortcut using overload of array index notation.
        #
        def [](generic_accept_type, generic_provided_type=nil)
          Class.new(self) do
            accept(generic_accept_type)
            provide(generic_provided_type) if generic_provided_type
          end
        end
      end

      # Accepted input type for this pipe.
      def accepts
        self.class.accepts
      end
    
      # Provided output type for this pipe.
      def provides
        self.class.provides
      end

      # True if this pipe provides an output that supports continuing
      # the flow by connecting further pipes to the sequence.
      def can_connect?
        !provides.nil?
      end

      # True if this pipe can accept input as an instance of the given type.
      def can_accept?(provided_type)
        accepts == provided_type.to_s.to_sym
      end

      # True if this pipe can provide output as an instance of the given type
      def can_provide?(provided_type)
        provides == provided_type.to_s.to_sym
      end
    end

    # Composable pipe that transforms an accepted input value into a provided output value.
    class Filter < Pipe
      def initialize(&block)
        @post_processor = block
      end
    
      def run(input)
        raise "#{input.class} not accepted"  unless can_accept?(input.class)
        
        output = filter(input)
        
        if @post_processor
          output = @post_processor.call(output)
        end

        raise "filter process generated wrong type" unless can_provide?(output.class)

        Result.new(output)
      end
    
      def filter(input)
        input
      end
    end
    
    # 
    class Manifold < Pipe  
      def initialize(*pipelines)
        @pipelines = pipelines
      end
    
      def run(input)
        children = @pipelines.map do |pipeline|
          pipeline.run(input)
        end

        Result.new(input, children)
      end

      def can_connect?
        false
      end
    end

    class Junction < Pipe
      def initialize(pipeline)
        @pipeline = pipeline
      end

      def run(input)
        child_result = @pipeline.run(input)
        Result.new(input, [child_result])
      end
    end
  end
end
