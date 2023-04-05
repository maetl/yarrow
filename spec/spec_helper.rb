if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
end

require 'rspec'
require 'rack/test'
require 'yarrow'

ENV['RACK_ENV'] = 'test'

module TestContentGraph
  class Pages
    attr_accessor :name, :title

    def initialize(meta)
      @name = meta[:name]
      @title = meta[:title]
    end

    def merge(other)
      self
    end
  end

  class Page
    attr_accessor :name, :title, :body

    def initialize(meta)
      @name = meta[:name]
      @title = meta[:title]
      @body = meta[:body]
    end
  end
end

def load_config_fixture(input_dir, source_map={pages: :page})
  Yarrow::Config::Instance.new(
    source_dir: Pathname.new("#{__dir__}/fixtures/sources/#{input_dir}"),
    output_dir: Pathname.new("#{__dir__}/fixtures/sources/output_dir"),
    content: Yarrow::Config::Content.new({
      module: "TestContentGraph",
      source_map: source_map
    }),
    output: Yarrow::Config::Output.new({
      generator: "web",
      template_dir: "templates"
    })
  )
end

def fixture_path(item_path)
  File.dirname(__FILE__) + "/fixtures/#{item_path}"
end

def load_fixture(item_path)
  File.read(fixture_path(item_path))
end

RSpec.configure do |config|
  config.formatter = :progress
  config.color = true

  RSpec::Matchers.define :collect_documents_with do |expected_attr, expected_list|
    match do |manifest|
      @actual = Set.new(manifest.documents.map { |resource| resource.send(expected_attr) })
      @expected = Set.new(expected_list)
      expect(@actual).to eq(@expected)
    end

    failure_message do
      "Collected `document.#{expected_attr}` values in manifest did not match expected"
    end

    diffable
    attr_reader :actual, :expected
  end
end

class Page

end

class Pages

end
