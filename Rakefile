$LOAD_PATH.unshift File.expand_path("./lib", __dir__)
require "yarrow"

task :version do
  puts Yarrow::VERSION
end

task :build do
  sh "gem build yarrow.gemspec"
end

task :publish do
  sh "gem push yarrow-#{Yarrow::VERSION}.gem"
end

task :clean do
  sh "rm yarrow-*.gem"
end
