require 'rake'
require 'rake/testtask'
require 'rdoc/task'

task :default => :test

desc 'Test the Janus rack middleware.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  #t.pattern = 'test/{unit,functional,integration,generators}/**/*_test.rb'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

Rake::RDocTask.new do |rdoc|
  rdoc.title = "Janus"
  rdoc.main = "README.rdoc"
  rdoc.rdoc_dir = "doc"
  rdoc.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rdoc.options << "--charset=utf-8"
end

begin
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    root_files = FileList["README.rdoc"]
    gem.name = "janus"
    gem.version = "0.7.1"
    gem.summary = "Authentication engine for Ruby on Rails."
    gem.email = "julien@portalier.com"
    gem.homepage = "http://github.com/ysbaddaden/janus"
    gem.description = "Janus is an authentication engine for Ruby on Rails."
    gem.authors = ['Julien Portalier']
    gem.files = root_files + FileList["{lib}/*"] + FileList["{lib}/**/*"]
    gem.extra_rdoc_files = root_files
    #gem.add_dependency 'rails', '>= 3.0'
    #gem.add_dependency 'bcrypt-ruby'
    #gem.add_dependency 'scrypt'
    gem.add_dependency 'addressable'
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  #puts "Jeweler, or one of its dependencies, is not available. Install it with: gem install jeweler"
end

