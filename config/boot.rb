require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

Object::RENDERED_OBJECTS = IdentitySet.new

require './lib/views/globals'
require './lib/views/object'
require './lib/views/exception'
require './lib/views/module'
require './lib/views/class'
require './lib/views/array'
require './lib/views/fixnum'
require './lib/views/float'
require './lib/views/string'
require './lib/views/symbol'
require './lib/views/nilclass'
require './lib/views/gsnmethod'
require './lib/views/thread'
require './lib/views/execblock'
require './lib/views/smalltalk_classes'
require './lib/views/proc'
require './lib/views/abstract_exception'
require './lib/views/boolean'
require './lib/views/abstract_dictionary'
require './lib/views/hash'
require './lib/views/system'

