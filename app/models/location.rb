class Location < ApplicationRecord
  has_many :plans
  has_many :publications
  has_many :default_settings
  
end
