class SyncRoleToWriterWorker < BaseWorker
  def perform(uid, role)
    params = { uid: uid, role: role, token: Settings.writer_token }
    Faraday.send(:post, Settings.writer_update_role_api, params)
  end
end
