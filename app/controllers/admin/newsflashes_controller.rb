class Admin::NewsflashesController < Admin::BaseController
  load_and_authorize_resource
  before_filter :check_original_input_format, only: [:create, :update]

  def index
    redirect_to :back unless %w(_pdnote _newsflash).include? params[:ptype]
    @newsflashes = @newsflashes.top_recent.includes({ author: :krypton_authentication }, :tags).tagged_with(params[:ptype]).page params[:page]
  end

  def new
    @newsflash.original_input = params[:original_input]
  end

  def update
    flash[:notice] = '更新成功' if @newsflash.update newsflash_params
    respond_with @newsflash, location: target_url
  end

  def create
    @newsflash.author = current_user
    flash[:notice] = '创建成功' if @newsflash.save
    respond_with @newsflash, location: target_url
  end

  def destroy
    @newsflash.destroy
    redirect_to :back, :notice => '删除成功'
  end

  def set_top
    @newsflash.set_top
    @newsflash.save
    redirect_to :back, :notice => '置顶成功'
  end

  def set_down
    @newsflash.set_down
    @newsflash.save
    redirect_to :back, :notice => '取消置顶成功'
  end

  private
  def newsflash_params
    params.require(:newsflash).permit(:original_input, :tag_list, :newsflash_topic_color_id, :cover)
  end

  def target_url
    if params[:newsflash][:tag_list].include? '_newsflash'
      admin_newsflashes_path(ptype: '_newsflash')
    else
      admin_newsflashes_path(ptype: '_pdnote')
    end
  end

  def check_original_input_format
     unless /^#(.+?)#(.+?)(---){1,}(.*)$/im =~ params[:newsflash][:original_input]
      newsflash_type = params["newsflash"]["tag_list"].include?('_newsflash') ? '_newsflash' : '_pdnote'
      flash[:error] = "内容格式不正确"
      if @newsflash.new_record?
        redirect_to new_admin_newsflash_path(ptype: newsflash_type, original_input: params[:newsflash][:original_input])
      else
        redirect_to edit_admin_newsflash_path(@newsflash, ptype: newsflash_type, original_input: params[:newsflash][:original_input])
      end
     end
  end
end
