class Admin::ToolsController < Admin::BaseController
  authorize_object :tools

  def redis
  end

  def redis_refresh
    ColumnsHeaderComponentWorker.new.perform
    HeadLinesComponentWorker.new.perform
    InfoFlowsComponentWorker.new.perform("主站")
    HotPostsComponentWorker.new.perform

    redirect_to :back, notice: 'Redis缓存更新成功'
  end
end
