require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "gibbon-sts"
  gem.homepage = "http://github.com/jaakkos/gibbon-sts"
  gem.license = "MIT"
  gem.summary = %Q{Gibbon STS is a simple API wrapper for interacting with MailChimp STS API 1.0. It just a fork from the wonderful Gibbon(https://github.com/amro/gibbon)}
  gem.description = %Q{Gibbon STS is a simple API wrapper for interacting with MailChimp STS API 1.0. It just a fork from the wonderful Gibbon(https://github.com/amro/gibbon)}
  gem.email = "jaakko@suutarla.com"
  gem.authors = ["Jaakko Suutarla"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  gem.add_runtime_dependency 'httparty', '> 0.6.0'
  gem.add_runtime_dependency 'json', '> 1.4.0'
  gem.add_development_dependency 'httparty', '> 0.6.0'
  gem.add_development_dependency 'json', '> 1.4.0'
  gem.add_development_dependency 'mocha', '> 0.9.11'
  gem.add_development_dependency 'rspec', '> 2.0'
  gem.add_development_dependency 'mail', '> 0'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "gibbon #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
