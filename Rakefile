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

