require "test_helper"

describe CheapMachines::Operations::KeyPair::Check do
  let(:described_class) { CheapMachines::Operations::KeyPair::Check }
  let(:subject) { described_class.new }

  describe "#call" do
    let(:ec2_client) { TestHelpers.ec2_client }
    let(:logger) { TestHelpers.logger }
    let(:input) { {ec2_client: ec2_client, logger: logger, key_pair_name: 'name-of-key-pair'} }

    describe "user has no key pairs" do
      before do
        ec2_client.stub_responses(:describe_key_pairs, {
          key_pairs: []
        })
      end
      it "returns a failure with error message" do
        result = subject.call(input)
        _(result).must_be_kind_of(::Dry::Monads::Result)
        _(result.failure?).must_equal(true)
        _(result.failure).must_equal("no key pair found with name: 'name-of-key-pair'")
      end
    end

    describe "user has key pairs but none with the supplied name" do
      before do
        ec2_client.stub_responses(:describe_key_pairs, {
          key_pairs: [{key_name: 'other-name'}]
        })
      end
      it "returns a failure with error message" do
        result = subject.call(input)
        _(result).must_be_kind_of(::Dry::Monads::Result)
        _(result.failure?).must_equal(true)
        _(result.failure).must_equal("no key pair found with name: 'name-of-key-pair'")
      end
    end

    describe "user has a key pair that matches the supplied name" do
      before do
        ec2_client.stub_responses(:describe_key_pairs, {
          key_pairs: [{key_name: 'name-of-key-pair'}, {key_name: 'other-name'}]
        })
      end
      it "searches for the key pair on AWS" do
        ec2_client_spy = Spy.on(ec2_client, :describe_key_pairs).and_call_through
        result = subject.call(input)
        assert ec2_client_spy.has_been_called_with?(filters: [{name: "key-name", values: ['name-of-key-pair']}])
      end
      it "returns a success with the input, but changing key_pair_name for the key_pair" do
        result = subject.call(input)
        _(result).must_be_kind_of(::Dry::Monads::Result)
        _(result.success?).must_equal(true)

        output = result.success
        _(output.keys.sort).must_equal([:ec2_client, :key_pair, :logger])
        _(output[:key_pair]).must_be_instance_of(Aws::EC2::Types::KeyPairInfo)
        _(output[:key_pair].key_name).must_equal('name-of-key-pair')
      end
    end

  end

end
