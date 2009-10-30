class AddSummaryHtmlToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :summary_html, :text
  end

  def self.down
    remove_column :posts, :summary_html
  end
end
