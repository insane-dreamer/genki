class AddCountryToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :country, :string
  end

  def self.down
    remove_column :comments, :column
  end
end
