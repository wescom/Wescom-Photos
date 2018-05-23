class AddSecondCaptionFilter < ActiveRecord::Migration[5.0]
  def self.up
    add_column :default_settings, :search_for_caption_text2, :string
  end

  def self.down
    remove_column :default_settings, :search_for_caption_text2
  end
end
