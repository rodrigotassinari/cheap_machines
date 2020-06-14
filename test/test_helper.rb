if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start do
    add_filter "/test/"
  end
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "cheap_machines"

require "minitest/autorun"
require "minispec-metadata"
require "vcr"
require "minitest-vcr"
require "webmock"
require "mocha/minitest"
require "spy/integration"
require "minitest/reporters"
require "timecop"

# turn on safe mode, only calls passing a block are allowed
Timecop.safe_mode = true

VCR.configure do |config|
  config.default_cassette_options = {record: :once, record_on_error: false}
  config.cassette_library_dir = "test/cassettes"
  config.hook_into :webmock
end
MinitestVcr::Spec.configure!

# Minitest::Reporters.use! [Minitest::Reporters::MeanTimeReporter.new]
Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new]

require_relative 'support/test_helpers'
