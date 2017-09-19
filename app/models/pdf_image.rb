class PdfImage < ApplicationRecord
  belongs_to :plan
  has_many :logs, :dependent => :destroy

  has_attached_file :image, 
      :styles => { 
        :large => ["500x500>",:jpg]
      },
      :url => "/system/pdf_images/:id/:style_:basename.:extension",  
      :path => ":rails_root/public/system/pdf_images/:id/:style_:basename.:extension",
      :default_url => '/images/no-image.jpg'

  validates_presence_of :publication, :message=>'Publication Name is required'
  validates_presence_of :section_name, :message=>'Section Name is required'
  validates_presence_of :pubdate, :message=>'PubDate is required'
  validates_presence_of :image, :message=>'Image is required'

  searchable :auto_index => true, :auto_remove => true do
    # Search fields
    text :pdf_text

    # Sort fields - must use 'string' instead of 'text'
    integer :pdf_image_location_id do
      plan.location_id if plan.present?
    end
    integer :pdf_image_pub_type_id do
      plan.publication_type_id if plan.present?
    end
    time :pubdate
    string :publication
    string :section_letter
    integer :page
    string :pdf_plan_publication do
      plan.pub_name if plan.present?
    end
    string :pdf_plan_section_name do
      plan.section_name if plan.present?
    end
  end

  def self.order_by_pubdate_section_page
    includes('plan').order('pubdate DESC').order('plans.pub_name').order('section_letter').order('plans.section_name').order('page')
  end

  def self.order_by_pubdate_sectionletter_page
    includes('plan').order('pubdate DESC').order('plans.pub_name').order('section_letter').order('page')
  end
end
