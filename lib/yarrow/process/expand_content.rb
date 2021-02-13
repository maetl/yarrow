module Yarrow
  module Process
    class ExpandContent < StepProcessor
      accepts String
      provides String

      def step(source)
        "#{source} | ExpandContent::Result"
      end
    end
  end
end
