class Plan < ApplicationRecord
  has_many :stories
  has_many :pdf_images
  belongs_to :location
  belongs_to :publication_type
  has_many :logs, :dependent => :destroy

end
