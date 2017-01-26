class Section < ApplicationRecord
  has_many :stories
  belongs_to :section_category

  def self.order_by_category_plus_name
    includes('section_category').order('section_categories.name').order('sections.name')
  end

  def category_plus_name
    if section_category_id?
      section_category_name+" - "+name
    else
      name
    end
  end
  
  def section_category_name
    if self.section_category_id?
      self.section_category.name
    end
  end
end
