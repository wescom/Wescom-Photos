class Publication < ApplicationRecord
  has_many :stories
  belongs_to :location
  belongs_to :publication_type
end
