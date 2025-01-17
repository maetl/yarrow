module Yarrow
  module Process
    class Filter
      attr_reader :accepts, :provides
    
      def initialize(accepts_type, provides_type, &block)
        @accepts = accepts_type
        @provides = provides_type
        @post_processor = block
      end
    
      def run(input)
        @post_processor.call(process(input))
      end
    
      def process(input)
        input
      end
    end
    
    class Manifold
      class << self
        attr_reader :accepts, :provides
    
        def accept(input_const)
          @accepts = input_const.to_s
        end
    
        def provide(output_const)
          @provides = output_const.to_s
        end
    
        def [](generic_accept_type, generic_provided_type=nil)
          Class.new(self) do
            accept(generic_accept_type)
            provide(generic_provided_type)
          end
        end
      end
    
      def initialize(*pipes)
        @pipes = pipes
      end
    
      def accepts
        self.class.accepts
      end
    
      def provides
        self.class.provides
      end
    
      def run(input)
        @pipes.each do |pipe|
          pipe.run(input)
        end
      end
    end

    class Task
      #attr_reader :source

      class << self
        attr_reader :accepted_input, :provided_output

        def accepts(input_const)
          @accepted_input = input_const.to_s
        end

        def provides(output_const)
          @provided_output = output_const.to_s
        end

        def [](generic_accept_type, generic_provided_type=nil)
          Class.new(self) do
            accepts(generic_accept_type)
            provides(generic_provided_type)
          end
        end
      end

      def initialize(*branches)
        @branches = branches || []
      end

      def accepts
        self.class.accepted_input
      end

      def provides
        self.class.provided_output
      end

      def can_connect?
        !provides.nil?
      end

      def can_accept?(provided)
        accepts == provided.to_s
      end

      def has_branches?
        @branches.empty?
      end

      def process(source)
        if has_branches?
          # begin
          result = step(source)
          # log.info("<Result source=#{result}>")
          # rescue
        else
          @branches.each do |conduit|
            conduit.run(source)
          end

          result = provides.empty? ? nil : source
        end

        result
      end
    end
  end
end
