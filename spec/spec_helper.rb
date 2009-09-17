require 'rubygems'
require 'spec'

$:.unshift(File.join(File.dirname(__FILE__), "..", 'lib')).unshift(File.dirname(__FILE__)).
  unshift(File.join(File.dirname(__FILE__), 'data'))
ROOT = File.join(File.dirname(__FILE__), '..') unless defined?(ROOT)
@@config = ''
ENVIRONMENT = 'test' unless defined?(ENVIRONMENT)
TEST = true unless defined?(TEST)
require 'freec'
require 'event'
require 'event_with_body'
