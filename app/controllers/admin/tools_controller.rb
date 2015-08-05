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
    columns = Column.all.order('id desc')
    report_name = "#{start_date.strftime("%F")}---#{end_date.strftime("%F")}"
    filename ||= "#{Rails.root}/tmp/data/#{report_name}.xls"
    Dir.mkdir(File.dirname(filename)) if !FileTest.exists?(File.dirname(filename))
    book = Spreadsheet::Workbook.new
    red_format = Spreadsheet::Format.new(:weight => :bold, :pattern_bg_color => :yellow , :color=> :red)

    sheet1 = book.create_worksheet :name => '所有文章'
    posts = Post.includes(:author).published.where("published_at >= ? and published_at <= ?", start_date ,end_date).order('published_at desc')
    sheet1.row(0).push "日期时段", report_name, "内的所有专栏文章"
    comments_counts = posts.map(&:comments_counts).compact.inject(0) {|sum, i| sum + i }
    favorites_count = posts.map(&:favorites_count).compact.inject(0) {|sum, i| sum + i }
    cache_views_count = posts.map(&:cache_views_count).compact.inject(0) {|sum, i| sum + i }
    cache_mobile_views_count = posts.map(&:cache_mobile_views_count).compact.inject(0) {|sum, i| sum + i }
    (0..10).select{|x| x % 2 == 1}.each do |i|
        sheet1.row(1).set_format(i, red_format)
    end
    sheet1.row(1).push '文章总数', posts.size, '总评论数', comments_counts, '总收藏数', favorites_count, '总浏览数', cache_views_count, '移动端浏览数', cache_mobile_views_count
    sheet1.row(3).push 'ID', '标题', 'URL', '阅读次数', '作者', '发表时间', '站内评论', '收藏数', '标题字数', '内容字数', '移动端阅读次数'
    posts.each_with_index do |post,i|
        sheet1.row(i+4).push post.url_code, post.title,"http://36kr.com/p/#{post.url_code}.html", post.cache_views_count, post.author.name, post.published_at, post.comments_counts, post.favorites_count, post.title.length, post.content.length, post.cache_mobile_views_count
    end

    sheet2 = book.create_worksheet :name => '综合统计'
    sheet2.row(0).push "所有专栏", "日期时段", report_name
    sheet2.row(1).push '专栏', '文章总数', '总评论数', '总收藏数', '总浏览击数', '移动端浏览数'

    columns.each_with_index do |column,c|
      sheet3 = book.create_worksheet :name => column.name.to_s
      sheet3.row(0).default_format = Spreadsheet::Format.new(:weight => :bold)
      (0..10).select{|x| x % 2 == 1}.each do |i|
        sheet3.row(2).set_format(i, red_format)
      end
      sheet3.row(4).default_format = Spreadsheet::Format.new(:weight => :bold)
      sheet3.row(0).push "#{column.name} (代码 #{column.id})", "日期时段", report_name
      posts = column.posts.includes(:author).published.where("published_at >= ? and published_at <= ?", start_date ,end_date).order('published_at desc')
      comments_counts = posts.map(&:comments_counts).compact.inject(0) {|sum, i| sum + i }
      favorites_count = posts.map(&:favorites_count).compact.inject(0) {|sum, i| sum + i }
      cache_views_count = posts.map(&:cache_views_count).compact.inject(0) {|sum, i| sum + i }
      cache_mobile_views_count = posts.map(&:cache_mobile_views_count).compact.inject(0) {|sum, i| sum + i }
      sheet3.row(2).push '文章总数', posts.size , '总评论数', comments_counts, '总收藏数', favorites_count, '总浏览击数', cache_views_count, '移动端浏览数', cache_mobile_views_count
      sheet3.row(4).push 'ID', '标题', 'URL', '阅读次数', '作者', '发表时间', '站内评论', '收藏数', '标题字数', '内容字数', '移动端阅读次数'
      posts.each_with_index do |post,i|
        sheet3.row(i+5).push post.url_code, post.title,"http://36kr.com/p/#{post.url_code}.html", post.cache_views_count, post.author.name, post.published_at, post.comments_counts, post.favorites_count, post.title.length, post.content.length, post.cache_mobile_views_count
      end

      (1..5).each do |i|
        sheet2.row(c+2).set_format(i, red_format)
      end
      sheet2.row(c+2).push column.name.to_s, posts.size , comments_counts, favorites_count, cache_views_count, cache_mobile_views_count
    end

    book.write filename
    send_file filename, :filename => "#{report_name}.xls"
    else
      redirect_to :back, notice: '下载码不正确'
    end
  end

end
