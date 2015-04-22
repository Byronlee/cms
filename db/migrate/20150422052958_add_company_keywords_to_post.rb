class AddCompanyKeywordsToPost < ActiveRecord::Migration
  def change
    add_column :posts, :company_keywords, :string, :array => true, default: []
  end
end
