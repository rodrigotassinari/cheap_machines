require "test_helper"

describe CheapMachines::Client do
  let(:described_class) { CheapMachines::Client }

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

  describe "#create_project" do
    let(:subject) do
      described_class.new(
        access_key_id: 'some-access-key',
        secret_access_key: 'some-secret-key',
        region: 'us-west-2'
      )
    end
    it "executes Operations::Projects::Create with supplied arguments" do
      CheapMachines::Operations::Projects::Create.
        any_instance.
        expects(:call).
        with(
          client: subject,
          project_name: 'my-project',
          key_pair_name: 'some-key-pair',
          public_ip: '123.123.123.123'
        ).
        returns(
          ::Dry::Monads::Success(true)
        )
      result = subject.create_project(
        project_name: 'my-project',
        key_pair_name: 'some-key-pair',
        public_ip: '123.123.123.123'
      )
      _(result).must_equal(true)
    end
  end
end
