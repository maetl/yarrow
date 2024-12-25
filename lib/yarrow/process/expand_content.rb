module Yarrow
  module Process
    class ExpandContent < Task
      accepts String
      provides String

      def step(source)
        "#{source} | ExpandContent::Result"
      end
    end
  end
end
