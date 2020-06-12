require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

require "dry/transaction"
require "aws-sdk-ec2"

module CheapMachines
  class Error < StandardError; end
end
