require "spec_helper"

describe NextComponentWorker, sidekiq: :fake do
  it { should be_retryable true }
  it { should be_retryable true }
  it { should be_processed_in :third_party_next }

  context ".perform" do
    let(:next_redis_db) { Redis::HashKey.new('next') }

    it "enqueues access next collections job" do
      subject.perform
      expect { next_redis_db["collections"] }.to_not be_nil
    end
  end
end
