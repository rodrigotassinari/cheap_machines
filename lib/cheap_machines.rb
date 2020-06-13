require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

require "dry/container"
require "dry/transaction"
require "dry/transaction/operation"
require "aws-sdk-ec2"

module CheapMachines
  class Error < StandardError; end
end
