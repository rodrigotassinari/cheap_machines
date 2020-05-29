require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module CheapMachines
  class Error < StandardError; end
  # Your code goes here...
end
