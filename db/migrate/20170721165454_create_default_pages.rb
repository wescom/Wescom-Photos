class CreateDefaultPages < ActiveRecord::Migration[5.0]
  def change
    create_table :default_pages do |t|

      t.string  :site_name
      t.string  :page_name

      t.string  :page_head
      t.string  :page_subhead
      t.text    :page_text1
      t.text    :page_text2
      t.text    :page_text3

      t.string  :email_contact

      t.timestamps
    end
  end
end
