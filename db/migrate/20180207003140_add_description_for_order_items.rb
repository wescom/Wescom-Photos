class AddDescriptionForOrderItems < ActiveRecord::Migration[5.0]
  def self.up
    add_column :order_items, :item_description, :string
    add_column :order_items, :item_quality, :string
  end

  def self.down
    remove_column :order_items, :item_description
    remove_column :order_items, :item_quality
  end
end
