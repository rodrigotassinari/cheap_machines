require "test_helper"

describe CheapMachines::Operations::KeyPair::Tag do
  let(:described_class) { CheapMachines::Operations::KeyPair::Tag }
  let(:subject) { described_class.new }

  describe "#call" do
    let(:ec2_client) { TestHelpers.ec2_client }
    let(:logger) { TestHelpers.logger }
    let(:key_pair) { stub("Aws::EC2::Types::KeyPairInfo", key_pair_id: "some-id", tags: []) }
    let(:input) { {ec2_client: ec2_client, logger: logger, key_pair: key_pair, project_name: "name-of-project"} }
    
    describe "ec2 client error" do
      before do
        # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/EC2/Errors.html
        ec2_client.stub_responses(:create_tags, Aws::EC2::Errors::AuthFailure.new({}, "invalid credentials"))
      end
      it "returns a failure with error message" do
        result = subject.call(input)
        _(result).must_be_kind_of(::Dry::Monads::Result)
        _(result.failure?).must_equal(true)
        _(result.failure).must_equal("error connecting to AWS: #<Aws::EC2::Errors::AuthFailure: invalid credentials>")
      end
    end

    describe "key_pair doesn't have the ProjectName tag" do
      before do
        ec2_client.stub_responses(:create_tags, {})
      end
      it "tags the key pair" do
        ec2_client_spy = Spy.on(ec2_client, :create_tags).and_call_through
        result = subject.call(input)
        assert ec2_client_spy.has_been_called_with?(
          resources: ["some-id"],
          tags: [{key: "ProjectName", value: "name-of-project"}]
        )
      end
      it "returns a success" do
        result = subject.call(input)
        _(result).must_be_kind_of(::Dry::Monads::Result)
        _(result.success?).must_equal(true)
      end
    end

    describe "key_pair has a different ProjectName tag" do
      let(:key_pair) { stub("Aws::EC2::Types::KeyPairInfo", key_pair_id: "some-id", tags: [Aws::EC2::Types::Tag.new(key: "ProjectName", value: "other-project")]) }
      before do
        ec2_client.stub_responses(:create_tags, {})
      end
      it "tags the key pair" do
        ec2_client_spy = Spy.on(ec2_client, :create_tags).and_call_through
        result = subject.call(input)
        assert ec2_client_spy.has_been_called_with?(
          resources: ["some-id"],
          tags: [{key: "ProjectName", value: "name-of-project"}]
        )
      end
      it "returns a success" do
        result = subject.call(input)
        _(result).must_be_kind_of(::Dry::Monads::Result)
        _(result.success?).must_equal(true)
      end
    end

    describe "key_pair already has the current ProjectName tag" do
      let(:key_pair) { stub("Aws::EC2::Types::KeyPairInfo", key_pair_id: "some-id", tags: [Aws::EC2::Types::Tag.new(key: "ProjectName", value: "name-of-project")]) }
      before do
        ec2_client.stub_responses(:create_tags, {})
      end
      it "does not tag the key pair" do
        ec2_client_spy = Spy.on(ec2_client, :create_tags)
        result = subject.call(input)
        refute ec2_client_spy.has_been_called?
      end
      it "returns a success" do
        result = subject.call(input)
        _(result).must_be_kind_of(::Dry::Monads::Result)
        _(result.success?).must_equal(true)
      end
    end
  end
    
end
