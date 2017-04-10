class StoryImagesController < ApplicationController

  def index
    default_settings = DefaultSetting.first
    @locations = Location.all.order("location_no")

    if params[:search_query]
      begin
        @story_images = StoryImage.search(:include => [:story]) do
          all do
            fulltext params[:search_query], :fields => [:media_webcaption, :media_printcaption, :media_originalcaption, :story_category_name, :story_subcategory_name]
            any do  
              # Filter all searches by caption text set within default_settings, ie. contains 'Bulletin'
              fulltext default_settings.search_for_caption_text, :fields => [:media_webcaption, :media_printcaption, :media_originalcaption]
            end
            any_of do  
              # Filter all searches by publish status and priority set within default_settings, ie. contains 'Published' and 'Web Ready'
#              if !default_settings.search_for_publish_status.empty?
#   Removed for now. Images 'published' with an article are not necessarily Web Ready. ie Image #665760
#                with(:publish_status, default_settings.search_for_publish_status)
#              end
              if !default_settings.search_for_priority.empty?
                with(:priority, default_settings.search_for_priority)
              end
            end
          end
          paginate(:page => params[:page], :per_page => 24)
          order_by :story_pubdate, :desc
          order_by :story_publication_name, :asc
      end
      rescue Errno::ECONNREFUSED
        render :text => "Search Server Down\n\n\n It will be back online shortly"
      end
    end
    @search_result_count = @story_images.total
    @total_images_count = StoryImage.count(:all)
  end

  def show
    @story_image = StoryImage.find(params[:id])

    # Check whether image is for sale
    if !image_for_sale?(@story_image)
      if admin?
        flash_message :notice, "Image not for sale: Admin only."
      else
    	  redirect_to root_path, :error => "Image not available"
    	end
    end
  end
  
  
  private
  def image_for_sale?(image)
    default_settings = DefaultSetting.first
    
    # Check captions for default_settings.search_for_caption_text
    caption_text = image.media_webcaption.to_s + image.media_printcaption.to_s + image.media_originalcaption.to_s
    if default_settings.search_for_caption_text.empty? or (caption_text.downcase.include? default_settings.search_for_caption_text.to_s.downcase)
      caption_text_okay = true
    else
      caption_text_okay = false
      flash_message :error, "Caption text '"+default_settings.search_for_caption_text+"' missing"
    end
      
    # Check image priority for default_settings.search_for_priority
    if default_settings.search_for_priority.empty? or default_settings.search_for_priority.include? image.priority
      image_priority_okay = true
    else
      image_priority_okay = false
      flash_message :error, "Priority = "+image.priority
    end
      
    # Check image whether image published based on default_settings.search_for_publish_status
    if default_settings.search_for_publish_status.empty? or default_settings.search_for_publish_status.include? image.publish_status
      image_published = true
    else
      image_published = false
      flash_message :error, "Publish status = "+image.publish_status
    end
      
    # Return TRUE if image is for sale based on default settings
    if caption_text_okay and image_priority_okay and image_published
      return true
    else
      return false
    end
  end
  
end
