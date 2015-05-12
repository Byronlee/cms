class PagesController < ApplicationController
  def show
    @page = Page.find_by_slug!(params[:slug])
  end

  def hire
    @jobs, @pages = [], []
    Dir.glob("#{Rails.root}/public/hires/proceed/*").map do |file|
      @jobs << (filename = File.basename(file, '.md')[2..-1])
      change_content = File.read(file)
      @pages << [filename, GitHub::Markdown.render_gfm(change_content).html_safe]
    end
  end
end
