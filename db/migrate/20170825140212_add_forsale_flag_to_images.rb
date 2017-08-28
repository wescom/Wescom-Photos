class AddForsaleFlagToImages < ActiveRecord::Migration[5.0]
  def self.up
    add_column :story_images, :forsale, :string
  end

  def self.down
    remove_column :story_images, :forsale
  end
end
