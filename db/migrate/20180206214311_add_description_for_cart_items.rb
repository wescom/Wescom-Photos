class AddDescriptionForCartItems < ActiveRecord::Migration[5.0]
  def self.up
    add_column :cart_items, :item_description, :string
    add_column :cart_items, :item_quality, :string
  end

  def self.down
    remove_column :cart_items, :item_description
    remove_column :cart_items, :item_quality
  end
end
