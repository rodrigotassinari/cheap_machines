require "test_helper"

describe CheapMachines do
  it "has a version number" do
    _(::CheapMachines::VERSION).wont_be_nil
    _(::CheapMachines::VERSION).must_match(/[0-9]\.[0-9]\.[0-9]/)
  end
end
