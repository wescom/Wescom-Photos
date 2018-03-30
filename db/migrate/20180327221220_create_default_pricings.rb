class CreateDefaultPricings < ActiveRecord::Migration[5.0]
  def change
    create_table :default_pricings do |t|

      t.integer  "default_setting_id"

      t.boolean :active
      t.string  :item_type
      t.string  :price_name
      t.string  :price_quality
      t.string  :price_tooltip
      t.string  :price_description
      t.decimal :price, precision: 12, scale: 3  

      t.timestamps
    end
  end
end
