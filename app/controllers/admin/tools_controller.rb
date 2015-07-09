class Admin::ToolsController < Admin::BaseController
  authorize_object :tools
  skip_before_action :verify_authenticity_token, :only => :gen_post_report

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

  def gen_post_report
    code = params[:report]["code"]
    start_date = DateTime.new params[:start_date]["report(1i)"].to_i, params[:start_date]["report(2i)"].to_i, params[:start_date]["report(3i)"].to_i
    end_date = DateTime.new params[:end_date]["report(1i)"].to_i, params[:end_date]["report(2i)"].to_i, params[:end_date]["report(3i)"].to_i
    if '8PXJ6GPOCHbAA'.eql? code.to_s
    columns = Column.all.order('id')
    report_name = "#{start_date.strftime("%F")}---#{end_date.strftime("%F")}"
    filename ||= "#{Rails.root}/tmp/data/#{report_name}.xls"
    Dir.mkdir(File.dirname(filename)) if !FileTest.exists?(File.dirname(filename))
    book = Spreadsheet::Workbook.new
    columns.each do |column|
      sheet = book.create_worksheet :name => column.name.to_s
      sheet.row(0).default_format = Spreadsheet::Format.new(:weight => :bold)
      sheet.row(2).default_format = Spreadsheet::Format.new(:weight => :bold)
      sheet.row(4).default_format = Spreadsheet::Format.new(:weight => :bold)
      sheet.row(0).push "#{column.name} (代码 #{column.id})", "日期时段", report_name
      posts = column.posts.includes(:author).where("published_at >= ? and published_at <= ?", start_date ,end_date)
      sheet.row(2).push '文章总数', posts.size , '总评论数', posts.map(&:comments_counts).compact.inject(0) {|sum, i| sum + i }, '总收藏数', posts.map(&:favorites_count).compact.inject(0) {|sum, i| sum + i } , '总浏览击数', posts.map(&:cache_views_count).compact.inject(0) {|sum, i| sum + i }
      sheet.row(4).push 'ID', '标题', 'URL', '阅读次数', '作者', '发表时间', '站内评论', '收藏数'
      posts.each_with_index do |post,i|
        sheet.row(i+5).push post.url_code, post.title,"http://36kr.com/p/#{post.url_code}.html", post.cache_views_count, post.author.name, post.published_at, post.comments_counts, post.favorites_count
      end
    end
    book.write filename
    send_file filename, :filename => "#{report_name}.xls"
    else
      redirect_to :back, notice: '下载码不正确'
    end
  end

end
