class AddPdfFilterFieldsToDefaultSettings < ActiveRecord::Migration[5.0]
  def self.up
    add_column :default_settings, :search_for_pdf_pubdate, :string
    add_column :default_settings, :search_for_pdf_pubtype, :string
  end

  def self.down
    remove_column :default_settings, :search_for_pdf_pubdate
    remove_column :default_settings, :search_for_pdf_pubtype
  end
end
