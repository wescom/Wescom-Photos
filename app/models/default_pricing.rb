class DefaultPricing < ApplicationRecord
  belongs_to :default_setting
  
  ITEM_TYPE_OPTIONS = ["StoryImage", "PDFImage"]
  PRICE_QUALITY_OPTIONS = ["Hires", "Lowres"]

end
