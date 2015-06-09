module PnoteHelper
  def display_pnote_summary(pnote, position)
    return nil if pnote.news_summaries.blank?
    summary = pnote.news_summaries.strip.split(/\r\n/).delete_if(&:blank?)
    if position == :first
      result = summary[0]
    elsif position == :last
      result = summary.last
    end
    return nil if result.blank?
    result.gsub(/^-/, '' )
  end
end