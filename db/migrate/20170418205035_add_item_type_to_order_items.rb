class AddItemTypeToOrderItems < ActiveRecord::Migration[5.0]
  def self.up
    add_column :order_items, :item_type, :string
  end

  def self.down
    remove_column :order_items, :item_type
  end
end
