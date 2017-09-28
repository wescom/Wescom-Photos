class AddLocationToDefaultSettings < ActiveRecord::Migration[5.0]
  def self.up
    add_column :default_settings, :location_id, :integer
  end

  def self.down
    remove_column :default_settings, :location_id, :integer
  end
end
