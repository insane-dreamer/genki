class AddAuthorToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :author, :string
    add_column :posts, :summary, :text
  end

  def self.down
    remove_column :posts, :summary
    remove_column :posts, :author
  end
end
