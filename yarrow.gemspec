$:.push File.expand_path('../lib', __FILE__)

require 'yarrow/version'

Gem::Specification.new do |spec|
  spec.name        = 'yarrow'
  spec.version     = Yarrow::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.summary     = 'Documentation generator based on a fluent data model.'
  spec.description = 'Yarrow is a tool for generating well structured documentation from a variety of input sources.'
  spec.authors     = ['Mark Rickerby']
  spec.email       = 'me@maetl.net'
  spec.files       = Dir.glob("{bin,lib}/**/*")
  spec.executables << 'yarrow'
  spec.executables << 'yarrow-server'
  spec.add_runtime_dependency 'hashie', '~> 3.5'
  spec.add_runtime_dependency 'mementus', '~> 0.8'
  spec.add_runtime_dependency 'activesupport', '~> 5.1'
  spec.add_runtime_dependency 'rack', '~> 2.0'
  spec.add_runtime_dependency 'rack-livereload', '~> 0.3'
  spec.add_runtime_dependency 'eventmachine', '~> 1.2'
  spec.add_runtime_dependency 'em-websocket', '~> 0.5.1'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'rack-test', '~> 0.8'
  spec.homepage = 'http://rubygemspec.org/gems/yarrow'
  spec.license = 'MIT'
end
