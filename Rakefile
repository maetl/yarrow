require 'rexml/document'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList['test/*_test.rb']
  #t.verbose = true
end

$version = File.read('VERSION')

task :version do
  xml = File.read('package.xml')
  
  pkg = REXML::Document.new(xml)
  pkg.elements.each('/package/version/*') do |version|
    version.text = $version
  end
  pkg.elements.each('/package/date') do |date|
    date.text = Time.now.strftime('%Y-%m-%d')
  end
  pkg.elements.each('/package/time') do |time|
    time.text = Time.now.strftime('%H:%M:%S')
  end
  
  File.open('package.xml', 'w') do |file|
    file.write(pkg)
  end
end

task :package do
  sh 'pear package'
end

task :publish do
  package = "Yarrow-#{$version}.tgz"
  sh "scp #{package} #{ENV['USER']}@#{ENV['HOST']}:/var/www/yarrow-channel/public"
  sh "ssh #{ENV['USER']}@#{ENV['HOST']} 'cd /var/www/yarrow-channel/public; pirum add /var/www/yarrow-channel/public #{package}'"
end

task :clean do
  sh 'rm Yarrow-*.tgz'
end

task :release => [:version, :package, :publish, :clean]