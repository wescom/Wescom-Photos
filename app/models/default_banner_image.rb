class DefaultBannerImage < ApplicationRecord
  belongs_to :default_settings

  has_attached_file :banner_image, 
      :styles => { 
        :small => ["150x150>",:jpg],
        :medium => ["1000x1000>",:jpg],
        :large => ["1500x1500>",:jpg]
      },
      :url => "/images/banner_images/:id/:style_:basename.:extension",  
      :path => ":rails_root/public/images/banner_images/:id/:style_:basename.:extension",
      :default_url => '/images/no-image.jpg'

    validates_attachment_content_type :banner_image, :content_type => ["image/jpg", "image/jpeg", "image/png"]

end
