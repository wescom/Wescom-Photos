class AddLocationFields < ActiveRecord::Migration[5.0]
  def self.up
    add_column :locations, :location_no, :integer
    add_column :locations, :newspaper_name, :string
    add_column :locations, :short_url_newspaper_name, :string
    add_index :locations, :short_url_newspaper_name, :unique => true
  end

  def self.down
    remove_column :locations, :location_no
    remove_column :locations, :newspaper_name
    remove_column :locations, :short_url_newspaper_name
    remove_index :locations, :short_url_newspaper_name
  end
end
