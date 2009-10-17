class AddPerPagetoSection < ActiveRecord::Migration
  def self.up
    add_column :sections, :per_page, :integer
  end

  def self.down
    remove_column :sections, :per_page
  end
end
