class AddHiLowResToImages < ActiveRecord::Migration[5.0]
  def self.up
    add_column :default_settings, :image_hi_res_price, :decimal, precision: 12, scale: 3
    add_column :default_settings, :image_low_res_price, :decimal, precision: 12, scale: 3
  end

  def self.down
    remove_column :default_settings, :image_hi_res_price, :decimal
    remove_column :default_settings, :image_low_res_price, :decimal
  end
end
