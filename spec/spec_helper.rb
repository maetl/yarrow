require 'rspec'
require 'yarrow'
require 'coveralls'

Coveralls.wear!

RSpec.configure do |config|
  config.formatter = 'documentation'
end
