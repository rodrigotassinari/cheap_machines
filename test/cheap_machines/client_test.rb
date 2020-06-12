require "test_helper"

describe CheapMachines::Client do
  
  describe ".new" do
    it "setups configuration with default logging to STDOUT" do
      client = CheapMachines::Client.new(
        access_key_id: 'some-access-key',
        secret_access_key: 'some-secret-key',
        region: 'us-west-2'
      )
      _(client.access_key_id).must_equal('some-access-key')
      _(client.secret_access_key).must_equal('some-secret-key')
      _(client.region).must_equal('us-west-2')
      _(client.logger).must_be_instance_of(::Logger)
      _(client.logger.level).must_equal(::Logger::INFO)
    end
    it "allows the usage of a custom logger" do
      class CustomLogger < ::Logger; end
      custom_logger = CustomLogger.new(STDOUT, level: ::Logger::DEBUG)
      client = CheapMachines::Client.new(
        access_key_id: 'some-access-key',
        secret_access_key: 'some-secret-key',
        region: 'us-west-2',
        logger: custom_logger
      )
      _(client.logger).must_be_instance_of(::CustomLogger)
      _(client.logger.level).must_equal(::Logger::DEBUG)
    end
  end

end
