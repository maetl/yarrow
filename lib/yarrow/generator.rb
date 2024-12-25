module Yarrow
  class ScanSource < Process::Task
    accepts Config::Instance
    provides Content::Graph

    def step(config)
      Yarrow::Content::Graph.from_source(config)
    end
  end

  class ExpandCollections < Process::Task
    accepts Content::Graph
    provides Content::Graph

    def step(content)
      model = Content::Model.new(content.config.content)
      model.expand(content.graph)
      content
    end
  end

  class FlattenManifest < Process::Task
    accepts Content::Graph
    provides Web::Manifest

    def step(content)
      puts content.config
      Web::Manifest.build(content)
    end
  end

  # class BuildOutput < Process::StepProcessor
  #   accepts Output::Manifest
  #   provides Output::Result
  # end

  # Generates documentation from a model.
  class Generator
    def initialize(config)
      @config = config
      @workflow = Process::Workflow.new(config.class)
    end

    def process(&block)
      workflow.connect(ScanSource.new)
      workflow.connect(ExpandCollections.new)
      workflow.connect(FlattenManifest.new)

      workflow.split(outputs.size) do |branched_workflows|

        outputs.each_with_index do |output, index|
          branched_workflows[index].connect(output.reconcile_step)
          branched_workflows[index].connect(output.generate_step)
        end

      end

      workflow.process(@config) do |result|
        block.call(result)
      end
    end

    def generate
      process do |manifest|
        generators.each do |generator|
          generator.generate(manifest)
        end
      end
    end

    #private

    attr_reader :config, :workflow

    def output_targets
      [Web::Generator.new(config)]
    end

    # pre_process_generators
    # post_process_generators
    # output_generators
    def generators
      [Web::Generator.new(config)]
    end
  end
end
