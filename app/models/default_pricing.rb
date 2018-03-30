class DefaultPricing < ApplicationRecord
  belongs_to :default_setting
  
  PRICE_TYPE_OPTIONS = ["", "StoryImage", "PDFImage"]

end
