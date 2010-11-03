class ChangeSections < ActiveRecord::Migration
  def self.up
    add_column :sections, :frontpage, :boolean, :default => true
    add_column :sections, :description, :text
  end

  def self.down
    remove_column :sections, :frontpage
    remove_column :sections, :description
  end
end
