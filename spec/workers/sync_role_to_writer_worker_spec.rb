require "spec_helper"

describe SyncRoleToWriterWorker, sidekiq: :fake do
  it { should be_retryable true }
  it { should be_retryable true }
  it { should be_processed_in :third_party_writer }

  context ".perform" do
    let(:user) { create :user, :admin }

    it "enqueues access job" do
      result = SyncRoleToWriterWorker.new.perform(user.sso_id, user.role)
      expect(result["status"]).to eql false
    end

    it "enqueues access next collections job" do
      # response = SyncRoleToWriterWorker.new.perform(user.sso_id, user.role)
      # expect(JSON.parse(response.body)['status']).to be false
    end
  end
end
