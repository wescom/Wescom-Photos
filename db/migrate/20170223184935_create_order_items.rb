class CreateOrderItems < ActiveRecord::Migration[5.0]
  def change
    create_table :order_items do |t|
      t.integer  "order_id"
      t.integer  "item_id"
      t.integer  "quantity"
      t.integer  "price_cents",    default: 0,     null: false
      t.string   "price_currency", default: "USD", null: false

      t.timestamps
    end
  end
end
