module Yarrow
  module Process
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
        @branches = branches
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
        accepts == provided
      end

      def process(source)
        if @branches.empty?
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
