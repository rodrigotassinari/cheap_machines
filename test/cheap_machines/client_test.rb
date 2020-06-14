require "test_helper"

describe CheapMachines::Client do
  let(:described_class) { CheapMachines::Client }

  describe ".new" do
    it "setups the EC2 client with supplied parameters and logs to STDOUT" do
      client = CheapMachines::Client.new(
        access_key_id: 'some-access-key',
        secret_access_key: 'some-secret-key',
        region: 'us-west-2'
      )

      _(client.logger).must_be_instance_of(::Logger)
      _(client.logger.level).must_equal(::Logger::INFO)

      _(client.ec2_client.instance_variable_get(:@config).credentials.access_key_id).must_equal('some-access-key')
      _(client.ec2_client.instance_variable_get(:@config).region).must_equal('us-west-2')

      _(client.logger).must_be_same_as(client.ec2_client.instance_variable_get(:@config).logger)
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
    it "executes Transactions::Projects::Create with supplied arguments" do
      CheapMachines::Transactions::Projects::Create.
        any_instance.
        expects(:call).
        once.
        with(
          ec2_client: subject.ec2_client,
          logger: subject.logger,
          project_name: 'my-project',
          key_pair_name: 'some-key-pair',
          public_ip: '123.123.123.123'
        ).
        returns(
          ::Dry::Monads::Success(some: 'output')
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
