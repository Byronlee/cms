class Admin::InfoFlowsController < Admin::BaseController
  def index
    @info_flows = Column.info_flows
  end

  def edit
    @columns = Column.all
  end
end
