require "test_helper"

describe CheapMachines do
  it "has a version number" do
    _(::CheapMachines::VERSION).wont_be_nil
    _(::CheapMachines::VERSION).must_match(/[0-9]\.[0-9]\.[0-9]/)
  end

  describe "#configure" do
    it "sets the configuration" do
      CheapMachines.configure do |config|
        config.access_key_id = 'foo'
        config.secret_access_key = 'bar'
      end

      _(CheapMachines.configuration.access_key_id).must_equal('foo')
      _(CheapMachines.configuration.secret_access_key).must_equal('bar')
    end
  end
end
