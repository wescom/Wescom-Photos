class ChangeDefaultPubTypeToStr < ActiveRecord::Migration[5.0]
  def self.up
    change_column :default_settings, :search_for_pdf_pubtypeId, :string
  end

  def self.down
    change_column :default_settings, :search_for_pdf_pubtypeId, :integer
  end
end
