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
  spec.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables << 'yarrow'
  spec.executables << 'yarrow-server'
  spec.add_runtime_dependency 'addressable', '~> 2.8'
  spec.add_runtime_dependency 'mementus', '~> 0.8'
  spec.add_runtime_dependency 'rack', '~> 3.0'
  spec.add_runtime_dependency 'rackup', '~> 0.2'
  spec.add_runtime_dependency 'rack-livereload', '~> 0.3'
  spec.add_runtime_dependency 'eventmachine', '~> 1.2'
  spec.add_runtime_dependency 'em-websocket', '~> 0.5.1'
  spec.add_runtime_dependency 'mustache', '~> 1.1.1'
  spec.add_runtime_dependency 'parallel', '~> 1.22.1'
  spec.add_runtime_dependency 'strings-inflection', '~> 0.1'
  spec.add_runtime_dependency 'strings-case', '~> 0.3'
  spec.add_runtime_dependency 'toml-rb', '~> 2.2.0'
  spec.add_runtime_dependency 'shale', '~> 1.0.0'
  spec.add_runtime_dependency 'phlex', '~> 1.8.1'
  spec.add_runtime_dependency 'kramdown', '~> 2.4.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.11'
  spec.add_development_dependency 'coveralls', '~> 0.8.23'
  spec.add_development_dependency 'rack-test', '~> 2.0'
  spec.homepage = 'http://rubygemspec.org/gems/yarrow'
  spec.license = 'MIT'
end
