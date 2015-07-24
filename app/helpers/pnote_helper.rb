module PnoteHelper
  def display_pnote_what(pnote)
    pnote.what || pnote.description_text
  end

  def display_pnote_summary(pnote, position)
    if pnote.news_summaries.blank?
      case position
      when :first
        pnote.how
      when :last
        pnote.think_it_twice
      end
    else
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
end