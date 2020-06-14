require "test_helper"

describe CheapMachines::Validations::Projects::CreateContract do
  let(:described_class) { CheapMachines::Validations::Projects::CreateContract }
  let(:subject) { described_class.new }

  describe "#call" do
    let(:valid_input) do
      {
        ec2_client: TestHelpers.ec2_client,
        logger: TestHelpers.logger,
        project_name: 'some-project-name',
        key_pair_name: 'some-key-pair-name',
        public_ip: '123.123.123.123'
      }
    end

    it "returns a success if all input is valid" do
      result = subject.call(valid_input)
      _(result.success?).must_equal(true)
      _(result.errors).must_be_empty
    end

    %i(ec2_client logger project_name key_pair_name public_ip).each do |key|
      it "requires #{key}" do
        result = subject.call(valid_input.reject { |k, _v| k == key })
        _(result.success?).must_equal(false)
        _(result.errors.to_h[key]).must_include("is missing")
      end
    end

    %i(project_name key_pair_name).each do |key|
      it "requires #{key} to be filled" do
        valid_input[key] = ""
        result = subject.call(valid_input)
        _(result.success?).must_equal(false)
        _(result.errors.to_h[key]).must_include("must be filled")
      end
    end

    ["", "123123123123", "123.123.123.", "123.123.123.123."].each do |invalid_ip|
      it "requires public_ip to be a valid IP address: rejects #{invalid_ip}" do
        valid_input[:public_ip] = invalid_ip
        result = subject.call(valid_input)
        _(result.success?).must_equal(false)
        _(result.errors.to_h[:public_ip]).must_include("is in invalid format")
      end
    end
    ["123.123.123.123", "127.0.0.1", "187.99.242.245"].each do |valid_ip|
      it "requires public_ip to be a valid IP address: allows #{valid_ip}" do
        valid_input[:public_ip] = valid_ip
        result = subject.call(valid_input)
        _(result.errors.to_h[:public_ip]).must_be_nil
      end
    end

    it "requires the project_name to be a valid AWS tag value" do
      valid_input[:project_name] = "a" * 256
      result = subject.call(valid_input)
      _(result.success?).must_equal(false)
      _(result.errors.to_h[:project_name]).must_include("must be less than 256 characters")

      valid_input[:project_name] = "this is; invalid"
      result = subject.call(valid_input)
      _(result.success?).must_equal(false)
      _(result.errors.to_h[:project_name]).must_include("must be comprised of letters, numbers, spaces and the following characters: + - = . _ : / @")
    end

    it "requires ec2_client to be an instance of ::Aws::EC2::Client" do
      valid_input[:ec2_client] = {foo: 'bar'}
      result = subject.call(valid_input)
      _(result.success?).must_equal(false)
      _(result.errors.to_h[:ec2_client]).must_include("must be Aws::EC2::Client")
    end

    it "requires logger to be a kind of ::Logger" do
      valid_input[:logger] = {foo: 'bar'}
      result = subject.call(valid_input)
      _(result.success?).must_equal(false)
      _(result.errors.to_h[:logger]).must_include("must quack like a Logger")

      class CustomLogger < ::Logger; end
      valid_input[:logger] = CustomLogger.new(RUBY_PLATFORM != 'i386-mingw32' ? '/dev/null' : 'NUL', level: ::Logger::DEBUG)
      result = subject.call(valid_input)
      _(result.errors.to_h[:logger]).must_be_nil
    end

  end
end
