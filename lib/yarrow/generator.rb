module Yarrow
  class ScanSource < Process::StepProcessor
    accepts Config::Instance
    provides Content::Graph

    def step(config)
      Yarrow::Content::Graph.from_source(config)
    end
  end

  class ExpandCollections < Process::StepProcessor
    accepts Content::Graph
    provides Content::Graph

    def step(content)
      expander = Content::CollectionExpander.new
      expander.expand(content.graph)
      content
    end
  end

  class FlattenManifest < Process::StepProcessor
    accepts Content::Graph
    provides Content::Manifest

    def step(content)
      Content::Manifest.build(content.graph)
    end
  end

  class BuildOutput < Process::StepProcessor
    accepts Content::Manifest
    provides Output::Result
  end

  # Generates documentation from a model.
  class Generator
    def initialize(config)
      @config = config
      @workflow = Process::Workflow.new(config)
    end

    def process(&block)
      workflow.connect(ScanSource.new)
      workflow.connect(ExpandCollections.new)
      workflow.connect(FlattenManifest.new)

      workflow.process do |result|
        block.call(result)
      end
    end

    private

    attr_reader :config, :workflow
  end
end
