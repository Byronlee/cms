require "spec_helper"

describe PostPublishWorker, sidekiq: :fake do
  it { should be_retryable true }
  it { should be_retryable true }
  it { should be_processed_in :scheduler }

  context ".perform" do
    let(:p_post) { create :post, :published }
    let(:r_post) { create :post, :reviewing }

    it "published post cant direct return true" do
      expect(subject.perform(p_post.id)).to be true
    end

    it "will_publish_at has past direct retruen true" do
      r_post.update(:will_publish_at => 2.days.ago.to_s)
    end

    it "valide params cerecct publish" do
      expect(subject.perform(r_post.id)).to be true
      expect(p_post.published?).to be true
    end
  end
end
