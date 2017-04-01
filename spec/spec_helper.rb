require "bundler/setup"
$:.unshift(File.join(File.dirname(__FILE__), "..", 'lib')).unshift(File.dirname(__FILE__)).
  unshift(File.join(File.dirname(__FILE__), 'data'))
ROOT = File.join(File.dirname(__FILE__), '..') unless defined?(ROOT)
@@config = ''
ENVIRONMENT = 'test' unless defined?(ENVIRONMENT)
TEST = true unless defined?(TEST)
require 'freec'
require 'event'
require 'event_with_body'
RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |expectations|
    expectations.syntax = [:should, :expect]
  end
  config.mock_with :rspec do |mocks|
    mocks.syntax = [:should, :receive]
  end
end
