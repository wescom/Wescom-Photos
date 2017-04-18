class OrderItem < ApplicationRecord
  belongs_to :order
  has_one :story_image, :foreign_key => :id, :primary_key => :item_id
  has_one :pdf_image, :foreign_key => :id, :primary_key => :item_id
end
