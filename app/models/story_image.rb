class StoryImage < ApplicationRecord
  belongs_to :story
  has_many :logs, :dependent => :destroy
  
  FORSALE_OPTIONS = ["", "For Sale", "NotForSale"]

  has_attached_file :image, 
      :styles => { 
        :large => ["500x500>",:jpg]
      },
      :url => "/system/db_images/:id/:style_:basename.:extension",  
      :path => ":rails_root/public/system/db_images/:id/:style_:basename.:extension",
      :default_url => '/images/no-image.jpg'
      # symlink this app's ./public/system to /u/apps/wescomarchive/current/public/system folder for the images 
      
      
  searchable :auto_index => true, :auto_remove => true do
    # Search fields
    # text fields will be full-text searchable. Other fields (e.g., integer and string) can be used to scope queries.
    # Sort fields - must use 'string' instead of 'text'.
    text :media_webcaption
    text :media_printcaption
    text :media_originalcaption
    text :media_printproducer, :default_boost => 2.0
    text :media_byline, :default_boost => 2.0
    text :media_name, :default_boost => 3.0
    text :media_project_group, :default_boost => 3.0
    text :media_category
    text :story_category_name do
      story.categoryname if story.present?
    end
    text :story_subcategory_name do
      story.subcategoryname if story.present?
    end
    text :forsale
    text :priority
    text :story_pubdate do
      story.pubdate.strftime('%-m/%-d/%y').to_s if story.present? and !story.pubdate.nil?
    end
    text :story_pubdate_full_year do
      story.pubdate.strftime('%-m/%-d/%Y').to_s if story.present? and !story.pubdate.nil?
    end
    text :story_pubdate_leading_zeros do
      story.pubdate.strftime('%m/%d/%y').to_s if story.present? and !story.pubdate.nil?
    end
    text :story_pubdate_leading_zeros_full_year do
      story.pubdate.strftime('%m/%d/%Y').to_s if story.present? and !story.pubdate.nil?
    end
    text :story_pubyear do
      story.pubdate.strftime('%y').to_s if story.present? and !story.pubdate.nil?
    end

    string :publish_status
    string :priority
    string :image_content_type
    integer :story_location_id do
      if story.present? 
        if story.plan.present?
          story.plan.location_id
        else
          story.web_pubnum
        end
      end
    end
    integer :story_pub_type_id do
      story.plan.publication_type_id if story.present? and story.plan.present?
    end
    string :story_publication_name do
      story.plan.pub_name if story.present? and story.plan.present?
    end
    string :story_section_name do
      story.plan.section_name if story.present? and story.plan.present?
    end
    integer :story_page do
      story.page if story.present?
    end
    time :story_pubdate do
      if story.present?
        story.pubdate
      else
        self.created_date
      end
    end
    string :image_type do
      self.image_type?
    end
    string :forsale
  end

  def self.order_by_pubdate
    includes(:story).order('stories.pubdate desc')
  end


  #  before_post_process :is_image?
  def is_image?
    !(image_content_type =~ /^image.*/).nil?
  end

  def image_type?
    if !image_content_type.present?
      return ""
    else
      if !(image_content_type =~ /^image.*/).nil?
        "Image"
      else
        "Graphic"
      end
    end
  end

  class << self
    def published
      where(:publish_status => 'Published')
    end
  end

  class << self
    def attached
      where(:publish_status => 'Attached')
    end
  end

  class << self
    def pagepdf
      where(:publish_status => 'PagePDF')
    end
  end

  def self.has_pubdate_in_range(date_from, date_to)
    date_from = Date.strptime(date_from, "%m/%d/%Y") if date_from.present? and date_from.length > 0
    date_to = Date.strptime(date_to, "%m/%d/%Y") if date_to.present? and date_to.length > 0
    if date_from.present? && date_to.present?
      includes(:story).where("stories.pubdate >= ?", date_from).where("stories.pubdate <= ?", date_to)
    else
      if date_from.present?
        includes(:story).where("stories.pubdate >= ?", date_from)
      else
        if date_to.present?
          includes(:story).where("stories.pubdate <= ?", date_to)
        else
          return scoped
        end
      end
    end
  end

  def self.has_section_name(name)
    return scoped unless name.present?
    includes(:story).where("stories.section_name = ?", name) if name
  end

  def self.has_publication_name(name)
    return scoped unless name.present?
    includes(:story).where("stories.publication_name = ?", name) if name
  end

  def self.has_story_category_or_subcategory(name)
    return scoped unless name.present?
    includes(:story).where("stories.categoryname = ? or stories.subcategoryname = ?", name, name) if name
  end

end
