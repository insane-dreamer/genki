class AddAuthorEmailToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :author_email, :string
  end

  def self.down
    remove_column :posts, :author_email
  end
end
