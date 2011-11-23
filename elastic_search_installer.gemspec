# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','elastic_search_installer_version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'elastic_search_installer'
  s.version = ElasticSearchInstaller::VERSION
  s.author = 'Asynchrony Solutions'
  s.email = 'info@asolutions.com'
  s.homepage = 'http://asynchrony.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Install Elastic Search'
# Add your other files here if you make them
  s.files = %w(
bin/elastic_search_installer
  )
  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables << 'elastic_search_installer'
  s.add_development_dependency('rake')
end
