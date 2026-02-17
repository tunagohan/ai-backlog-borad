class AddImageUrlsToIssues < ActiveRecord::Migration[7.2]
  def change
    add_column :issues, :image_urls, :text, null: false, default: "[]"
  end
end
