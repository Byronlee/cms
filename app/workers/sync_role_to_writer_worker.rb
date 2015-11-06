class SyncRoleToWriterWorker < BaseWorker
  sidekiq_options :queue => :third_party_writer, :backtrace => true

  def perform(uid, role)
    params = { uid: uid, role: role, token: Settings.writer_token }
    response = Faraday.send(:post, Settings.writer_update_role_api, params)
    return { status: false, msg: 'Writer服务器不在线，链接失败! 502' } if response.status.eql?(502)
    return { status: false, msg: response.body } unless response.success?
    @result = JSON.parse(response.body) rescue { status: false, msg: response.body }
    @result
  end
end
