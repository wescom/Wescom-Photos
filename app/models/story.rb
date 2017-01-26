class Story < ApplicationRecord
  belongs_to :publication
  belongs_to :section
  belongs_to :paper
  belongs_to :plan

  has_and_belongs_to_many :keywords
  has_many :story_topics
  has_many :topics, :through => :story_topics
  has_many :correction_links
  has_many :corrections, :through => :correction_links
  has_many :inverse_correction_links, :class_name => 'CorrectionLink', :foreign_key => "correction_id"
  has_many :corrected_stories, :through => :inverse_correction_links, :source => :story
  has_many :story_images, :dependent => :destroy
  has_many :logs, :dependent => :destroy

  validates :pubdate, :presence => true, :on => :update
  validates :page, :presence => true, :numericality => true, :on => :update

  def publish_year
    if !pubdate.nil?
      pubdate.strftime("%Y")
    end
  end
  
  def self.order_by_pub_section_page
    includes(:plan).order('plans.pub_name').order('plans.section_name').order('page')
  end
  
  def section_name
    self.plan.section_name if self.plan.present?
  end
  
  def publication_name
    self.plan.pub_name if self.plan.present?
  end
  
  def self.has_pubdate_in_range(date_from, date_to)  
    return scoped unless date_from.present? AND date_to.present?
    where("pubdate >= ? AND pubdate <= ?", date_from, date_to)  
  end
end
