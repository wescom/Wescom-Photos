class AddAdminFlagtoDefaultPricings < ActiveRecord::Migration[5.0]
    def self.up
      add_column :default_pricings, :admin_only, :boolean
    end

    def self.down
      remove_column :default_pricings, :admin_only
    end
end
