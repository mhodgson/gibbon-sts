require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rspec/core'
require 'rspec/mocks'
require 'rspec/expectations'
require 'shoulda'

RSpec.configure do |config|
  config.color_enabled = true
end

require 'gibbon_sts'