module Yarrow
  module Process
    class ExtractSource < StepProcessor
      accepts String
      provides String

      def step(source)
        "#{source} | ExtractSource::Result"
      end
    end
  end
end
