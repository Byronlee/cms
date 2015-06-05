module PnoteHelper
  def display_pnote_summary(pnote)
  	return nil if pnote.news_summaries.blank?
  	summary = pnote.news_summaries.strip.split(/\r\n/).delete_if(&:blank?)
  	return nil if summary[0].blank?
  	summary[0].gsub(/^-/, '' )
  end
end