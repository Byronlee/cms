require "spec_helper"
require "common"

describe "#valid_of?" do
  context "url is invalid" do
    let(:result) { valid_of?('baidu.com') }
    it { expect(result.first).to eq false }
  end

  context "url is valid" do
    subject { valid_of?('http://www.baidu.com') }
    it { should be_true }
  end
end

describe "#get_customer_meta_of" do
  it do
    response = double(body: File.read(File.expand_path('../../factories/og.html', __FILE__)))
    RedirectFollower.stub(:new) { double(resolve: response) }
    og = OpenGraph.new("http://test.host/child_page")

    expect(get_customer_meta_of(og, :title)).to eq '装进背包里的智能吉他：Jamstik+'
    expect(get_customer_meta_of(og, :type)).to eq 'video.movie'
    expect(get_customer_meta_of(og, :video, :duration).to_i).to eq 59
  end
end
