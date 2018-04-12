class AddActiveFieldToDefaults < ActiveRecord::Migration[5.0]
  def self.up
    add_column :default_settings, :active, :boolean
  end

  def self.down
    remove_column :default_settings, :active
  end
end
