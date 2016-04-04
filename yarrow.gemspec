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
  spec.add_runtime_dependency 'hashie'
  spec.add_runtime_dependency 'sprockets'
  spec.add_runtime_dependency 'mementus', '< 0.2.0'
  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'rack'
  spec.add_runtime_dependency 'rack-livereload'
  spec.add_runtime_dependency 'eventmachine'
  spec.add_runtime_dependency 'em-websocket'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rack-test'
  spec.homepage = 'http://rubygemspec.org/gems/yarrow'
  spec.license = 'MIT'
end
