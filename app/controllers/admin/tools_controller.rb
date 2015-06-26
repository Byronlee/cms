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

  def report
  end

  def gen_column_report
    columns = Column.all.order('id')
    columns_export_file ||= "#{Rails.root}/tmp/data/columns-#{DateTime.now.strftime("%F")}.csv"
    Dir.mkdir(File.dirname(columns_export_file)) if !FileTest.exists?(File.dirname(columns_export_file))
    CSV.open(columns_export_file, "wb") do |csv|
        csv << [ '专栏编号', '专栏名称', '文章数']
        columns.each do |column|
          csv << [ column.id, column.name, column.posts.size ]
        end
    end
    send_file columns_export_file, :filename => "columns-#{DateTime.now.strftime("%F")}.csv"
  end

  def gen_post_report
    columns = Column.all.order('id')
    post_export_file ||= "#{Rails.root}/tmp/data/post-#{DateTime.now.strftime("%F")}.csv"
    Dir.mkdir(File.dirname(post_export_file)) if !FileTest.exists?(File.dirname(post_export_file))
    CSV.open(post_export_file, "wb") do |csv2|
      csv2 << [ 'url_code', '文章标题', '评论数', '收藏数', '浏览击数']
      columns.each do |column|
        column.posts.each do |post|
          csv2 << [ post.url_code, post.title, post.comments_counts, post.favorites_count, post.cache_views_count ]
        end
      end
    end
    send_file post_export_file, :filename => "post-#{DateTime.now.strftime("%F")}.csv"
  end

end
