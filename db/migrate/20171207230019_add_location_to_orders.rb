class AddLocationToOrders < ActiveRecord::Migration[5.0]
  def self.up
    add_column :orders, :location_id, :integer
  end

  def self.down
    remove_column :orders, :location_id, :integer
  end
end
