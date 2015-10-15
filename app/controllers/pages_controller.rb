class PagesController < ApplicationController
  def show
    @page = Page.find_by_slug!(params[:slug])
  end

  def hire
    Rails.cache.delete_matched(:v3_page_hire_) if params[:force_flush] == 'true'
    @jobs, @pages = Rails.cache.fetch(:v3_page_hire_, expires_in: 1.hour) do
      jobs, pages = [], []
      Rails.logger.info "reloading hire page text"
      Dir.glob("#{Rails.root}/public/hires/proceed/*")
      .sort do |a ,b|
        hire_file_num(a) <=> hire_file_num(b)
      end
      .map do |file|
        jobs << (filename = File.basename(file, '.md').match(/\.(.+)/)[1].to_s)
        change_content = File.read(file)
        pages << [filename, GitHub::Markdown.render_gfm(change_content).html_safe]
      end
    [jobs, pages]
    end
  end

  private
  def hire_file_num(path)
    path.split('/').last.split('.').first.to_i
  end
end
