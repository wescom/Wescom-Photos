class DefaultSetting < ApplicationRecord
  belongs_to :location
  has_many  :default_banner_images
  has_many  :default_pricing
  
  has_attached_file :site_image, 
      :styles => { 
        :small => ["300x300>",:jpg],
        :medium => ["600x600>",:jpg],
        :large => ["1000x1000>",:jpg]
      },
      :url => "/images/site_images/:id/:style_:basename.:extension",  
      :path => ":rails_root/public/images/site_images/:id/:style_:basename.:extension",
      :default_url => '/images/no-image.jpg'

      validates_attachment_content_type :site_image, :content_type => ["image/jpg", "image/jpeg", "image/png"]

end
