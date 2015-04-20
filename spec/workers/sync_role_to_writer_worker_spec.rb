require "spec_helper"

describe SyncRoleToWriterWorker, sidekiq: :fake do
  it { should be_retryable true }
  it { should be_retryable true }
  it { should be_processed_in :krx2015 }

  context ".perform" do
    let(:user) { create :user, :admin }

    it "enqueues access job" do
      expect do
        SyncRoleToWriterWorker.perform_async(user.sso_id, user.role)
      end.to change(SyncRoleToWriterWorker.jobs, :size).by(1)
    end

    it "enqueues access next collections job" do
      response = SyncRoleToWriterWorker.new.perform(user.sso_id, user.role)
      expect(JSON.parse(response.body)['status']).to be false
    end
  end
end
