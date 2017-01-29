class StoryImage < ApplicationRecord
  belongs_to :story

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
    text :media_printcaption
    text :media_originalcaption
    text :media_printproducer, :default_boost => 2.0
    text :media_byline, :default_boost => 2.0
    text :media_name, :default_boost => 3.0
    text :media_project_group, :default_boost => 3.0
    text :publish_status
    text :image_content_type

    # Sort fields - must use 'string' instead of 'text'
    integer :story_location_id do
      story.plan.location_id if story.present? and story.plan.present?
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
      story.pubdate if story.present?
    end
    string :image_type do
      self.image_type?
    end

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

end
