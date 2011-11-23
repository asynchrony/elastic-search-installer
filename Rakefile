require 'rake/clean'
require 'rubygems'
require 'rake/packagetask'
require 'rdoc/task'
require 'rspec/core/rake_task'

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc","lib/**/*.rb","bin/**/*")
  rd.title = 'Install Elastic Search'
end

spec = eval(File.read('elastic_search_installer.gemspec'))

Rake::PackageTask.new(spec, ElasticSearchInstaller::VERSION) do |pkg|
end

desc "Run the code examples in spec"
task :spec do
  RSpec::Core::RakeTask.new do |t|
    t.pattern = "./specs/**/*_spec.rb"
  end
end

task :default => :spec
