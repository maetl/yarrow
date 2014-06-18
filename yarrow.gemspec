$:.push File.expand_path("../lib", __FILE__)
require "yarrow/version"

Gem::Specification.new do |s|
  s.name        = "yarrow"
  s.version     = Yarrow::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Documentation generator"
  s.description = "Documentation generator"
  s.authors     = ["Mark Rickerby"]
  s.email       = "me@maetl.net"
  s.files       = Dir.glob("{bin,lib}/**/*")
  s.executables << 'yarrow'
  s.add_runtime_dependency "hashie"
  s.add_runtime_dependency "sprockets"
  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.homepage = "http://rubygems.org/gems/yarrow"
end
