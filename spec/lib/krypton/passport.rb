require "spec_helper"

describe Krypton::Passport do
  describe "#new" do
    subject { Krypton::Passport.new("ooxx") }
    it { should_not be_nil }
  end
end
