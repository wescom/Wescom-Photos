class AddAttachmentSiteImageToDefaultSettings < ActiveRecord::Migration
  def self.up
    change_table :default_settings do |t|
      t.attachment :site_image
    end
  end

  def self.down
    remove_attachment :default_settings, :site_image
  end
end
