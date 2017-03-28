class CreateDefaultSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :default_settings do |t|

      t.decimal :image_price, precision: 12, scale: 3  
      t.decimal :pdf_price, precision: 12, scale: 3  

      t.text  :image_use_license
      t.string :confirmation_from_email

      t.string  :home_main_images
      t.text    :home_welcome_text
      t.string  :home_image_cat1_name
      t.string  :home_image_cat1
      t.string  :home_image_cat2_name
      t.string  :home_image_cat2
      t.string  :home_image_cat3_name
      t.string  :home_image_cat3
      
      t.string  :search_for_publish_status
      t.string  :search_for_priority
      t.string  :search_for_caption_text
      
      t.timestamps
    end
  end
end
