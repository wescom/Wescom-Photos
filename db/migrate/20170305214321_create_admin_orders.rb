class CreateAdminOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_orders do |t|
      t.decimal :image_price, precision: 12, scale: 3  
      t.decimal :pdf_price, precision: 12, scale: 3  
      t.string :confirmation_from_email
      
      t.timestamps
    end
  end
end
