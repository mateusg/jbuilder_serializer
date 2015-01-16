if ENV['CI']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'bundler/setup'
require 'jbuilder/serializer'

RSpec.configure do |config|
  config.disable_monkey_patching!
end
