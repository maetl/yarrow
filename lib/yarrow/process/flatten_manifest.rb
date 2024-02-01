module Yarrow
  module Process
    class FlattenManifest < Yarrow::Workflow::StepProcessor
      accepts Yarrow::Content::Graph
      provides Yarrow::Web::Manifest
  
      def step(content)
        Web::Manifest.build(content.graph)
      end
    end
  end
end