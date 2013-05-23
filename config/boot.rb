require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

Object::RENDERED_OBJECTS = IdentitySet.new

require './config/bootstrap_classes'
require './lib/ruby_workspace'
require './lib/code_evaluation'

