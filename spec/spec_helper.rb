if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
end

require 'rspec'
require 'rack/test'
require 'yarrow'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.formatter = :progress
  config.color = true
end
