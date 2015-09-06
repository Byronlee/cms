class Admin::NewsflashesController < Admin::BaseController
  load_and_authorize_resource

  def index
    redirect_to :back unless %w(_pdnote _newsflash).include? params[:ptype]
    @newsflashes = @newsflashes.top_recent.includes({ author: :krypton_authentication }, :tags).tagged_with(params[:ptype]).page params[:page]
  end

  def new
  end

  def update
    if @newsflash.update newsflash_params
      flash[:notice] = '更新成功'
      respond_with @newsflash, location: target_url
    else
      params[:ptype] = ptype
      render :edit
    end
  end

  def create
    @newsflash.author = current_user
    if @newsflash.save
      flash[:notice] = '创建成功'
      respond_with @newsflash, location: target_url
    else
      params[:ptype] = ptype
      render :new
    end
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

  def target_url
    admin_newsflashes_path(ptype: ptype)
  end

  def ptype
    (params[:newsflash][:tag_list].include? '_newsflash') ? '_newsflash' : '_pdnote'
  end

  def newsflash_params
    params.require(:newsflash).permit(:hash_title, :tag_list, :description_text, :news_url, :news_url_type, :column_id, :what, :how, :think_it_twice, :cover, :display_in_infoflow)
  end
end
