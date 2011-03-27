require 'rake'
require 'rake/testtask'

task :default => :test

desc 'Test the Janus rack middleware.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    root_files = FileList["README.rdoc"]
    s.name = "janus"
    s.version = "0.1.0"
    s.summary = "Authentication engine for Ruby on Rails."
    s.email = "ysbaddaden@gmail.com"
    s.homepage = "http://github.com/ysbaddaden/janus"
    s.description = "Authentication engine for Ruby on Rails."
    s.authors = ['Julien Portalier']
    s.files =  root_files + FileList["{lib}/*"]
    s.extra_rdoc_files = root_files
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: gem install jeweler"
end

