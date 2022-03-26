if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
end

require 'rspec'
require 'rack/test'
require 'yarrow'

ENV['RACK_ENV'] = 'test'

def load_config_fixture(input_dir)
  Yarrow::Config::Instance.new(
    source: Pathname.new("#{__dir__}/fixtures/sources/#{input_dir}"),
    content: Pathname.new("#{__dir__}/fixtures/sources/content_dir"),
    output_dir: Pathname.new("#{__dir__}/fixtures/sources/output_dir"),
  )
end

RSpec.configure do |config|
  config.formatter = :progress
  config.color = true
end
