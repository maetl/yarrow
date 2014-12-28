require 'coveralls'
Coveralls.wear!

require 'rspec'
require 'yarrow'

RSpec.configure do |config|
  config.formatter = 'documentation'
end
