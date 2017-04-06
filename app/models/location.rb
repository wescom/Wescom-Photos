class Location < ApplicationRecord
  has_many :plans
  has_many :publications
    
end
