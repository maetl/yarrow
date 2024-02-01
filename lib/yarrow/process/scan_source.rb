module Yarrow
  module Process
    class ScanSource < Yarrow::Workflow::StepProcessor
      accepts Yarrow::Configuration::Instance
      provides Yarrow::Content::Graph
  
      def step(config)
        Yarrow::Content::Graph.from_source(config)
      end
    end
  end
end