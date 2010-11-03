class AddSections < ActiveRecord::Migration
  def self.up
    create_table :sections, :force => true do |t|
      t.string :name
      t.timestamps
    end
    add_column :posts, :section_id, :integer
    add_index "posts", ["section_id"], :name => "index_posts_on_section_id"
  end

  def self.down
    remove_index "posts", ["section_id"]
    remove_column :posts, :section_id
    drop_table :sections
  end
end
