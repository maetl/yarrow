module Yarrow
  class ScanSource < Process::Filter
    accept Config::Instance
    provide Content::Graph

    def filter(config)
      Yarrow::Content::Graph.from_source(config)
    end
  end

  class ExpandCollections < Process::Filter
    accept Content::Graph
    provide Content::Graph

    def filter(content)
      model = Content::Model.new(content.config.content)
      model.expand(content.graph)
      content
    end
  end

  class FlattenManifest < Process::Filter
    accept Content::Graph
    provide Web::Manifest

    def filter(content)
      puts content.config
      Web::Manifest.build(content)
    end
  end

  # class BuildOutput < Process::StepProcessor
  #   accept Output::Manifest
  #   provide Output::Result
  # end

  # Generates documentation from a model.
  class Generator
    def initialize(config)
      @config = config
      @workflow = Process::Pipeline.new(config.class)
    end

    def process(&block)
      workflow.connect(ScanSource.new)
      workflow.connect(ExpandCollections.new)
      workflow.connect(FlattenManifest.new)

      workflow.manifold(config.output.size) do |branched_workflows|
        config.output.each_with_index do |output, index|
          # FlattenManifest
          # GenerateOutput
          branched_workflows[index].connect(output.reconcile_step)
          branched_workflows[index].connect(output.generate_step)
        end
      end

      # workflow.process(@config) do |result|
      #   block.call(result)
      # end
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
