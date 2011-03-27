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

  Jeweler::Tasks.new do |gem|
    root_files = FileList["README.rdoc"]
    gem.name = "janus"
    gem.version = "0.1.2"
    gem.summary = "Authentication engine for Ruby on Rails."
    gem.email = "ysbaddaden@gmail.com"
    gem.homepage = "http://github.com/ysbaddaden/janus"
    gem.description = "Authentication engine for Ruby on Rails."
    gem.authors = ['Julien Portalier']
    gem.files =  root_files + FileList["{lib}/*"]
    gem.extra_rdoc_files = root_files
    gem.add_dependency 'bcrypt-ruby'
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: gem install jeweler"
end

