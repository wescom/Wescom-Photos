class CreateDefaultBannerImages < ActiveRecord::Migration[5.0]
  def change
    create_table :default_banner_images do |t|
      t.integer :default_setting_id
      t.attachment :banner_image
      t.timestamps
    end
  end

  def self.down
    remove_table :default_banner_images
  end
end
