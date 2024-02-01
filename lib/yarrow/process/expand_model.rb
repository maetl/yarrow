module Yarrow
  module Process
    class ExpandModel < Yarrow::Workflow::StepProcessor
      accepts Yarrow::Content::Graph
      provides Yarrow::Content::Graph
  
      def step(content)
        model = Content::Model.new(content.config.content)
        model.expand(content.graph)
        content
      end
    end
  end
end