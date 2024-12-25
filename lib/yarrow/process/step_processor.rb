module Yarrow
  module Process
    class Task
      attr_reader :source

      class << self
        attr_reader :accepted_input, :provided_output

        def accepts(input_const)
          @accepted_input = input_const.to_s
        end

        def provides(output_const)
          @provided_output = output_const.to_s
        end

        def [](generic_type)
          @accepted_input = generic_type.to_s
          self
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

      def can_connect?
        true
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

    class BranchingTask < Task
      def initialize(*branches)
        @branches = branches
      end

      def can_connect?
        false
      end

      def process(source)
        @branches.each do |conduit|
          conduit.run(source)
        end

        nil
      end
    end
  end
end
