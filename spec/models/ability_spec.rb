require "spec_helper"
require "cancan/matchers"

describe Ability do
  subject { Ability.new user }

  context "member" do
    let(:user) { create :user }
    it(:welcome) {
      should be_able_to(:index, :welcome)
    }
  end

  context "anonymous" do
    let(:user) { nil }
    it(:welcome) {
      should be_able_to(:index, :welcome)
    }
  end

end
