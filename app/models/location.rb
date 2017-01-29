class Location < ApplicationRecord
  has_many :plans
  has_many :publications
  
  def self.order_by_location_type_pub_section
    includes([:plans]).order('name').order('plans.pub_name').order('plans.section_name').order('plans.import_pub_name').order('plans.import_section_name')
  end
  
end
