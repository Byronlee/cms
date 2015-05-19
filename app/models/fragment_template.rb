# == Schema Information
#
# Table name: fragment_templates
#
#  id           :integer          not null, primary key
#  key          :string(255)
#  name         :string(255)
#  content      :text
#  content_type :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class FragmentTemplate < ActiveRecord::Base
  validates_presence_of :key, :name, :content, :content_type
  validates_uniqueness_of :key
  extend Enumerize

  enumerize :content_type, in: [:markdown, :plain], scopes: :shallow, methods: true

  def display_content
    @display_content ||= begin
      case content_type
      when :markdown
        content_parsed = Liquid::Template.parse(content).render!
        Redcarpet::Markdown.new(Redcarpet::Render::HTML.new).render(content_parsed)
      else
        content
      end
    end
  end
end
