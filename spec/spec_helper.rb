if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
end

require 'rspec'
require 'yarrow'

RSpec.configure do |config|
  config.formatter = :progress
  config.color = true
end
