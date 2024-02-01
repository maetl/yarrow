require "yarrow/workflow/pipeline"
require "yarrow/workflow/step_processor"
require "yarrow/process/scan_source"
require "yarrow/process/expand_model"
require "yarrow/process/flatten_manifest"
#require "yarrow/process/build_output"

module Yarrow
  # Generates documentation from a model.
  class Generator
    attr_reader :config, :pipeline

    def initialize(config)
      @config = config
      @pipeline = Workflow::Pipeline.new(config)
    end

    def process(&block)
      pipeline.connect(Process::ScanSource.new)
      pipeline.connect(Process::ExpandModel.new)
      pipeline.connect(Process::FlattenManifest.new)

      pipeline.process do |result|
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

    def generators
      [Web::Generator.new(config)]
    end
  end
end
