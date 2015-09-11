class PagesController < ApplicationController
  def show
    @page = Page.find_by_slug!(params[:slug])
  end

  def hire
    @jobs, @pages = Rails.cache.fetch(:v3_page_hire_, expires_in: 1.hour) do
      jobs, pages = [], []
      Rails.logger.info "reloading hire page text"
      Dir.glob("#{Rails.root}/public/hires/proceed/*").map do |file|
        jobs << (filename = File.basename(file, '.md').match(/\.(.+)/)[1].to_s)
        change_content = File.read(file)
        pages << [filename, GitHub::Markdown.render_gfm(change_content).html_safe]
      end
      [jobs, pages]
    end
  end
end
