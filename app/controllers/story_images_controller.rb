class StoryImagesController < ApplicationController

  def index
    default_settings = DefaultSetting.where("location_id" => current_location).first
    @default_settings = DefaultSetting.where("location_id" => current_location).first

    if params[:search_query]
      begin
        @story_images = StoryImage.search(:include => [:story]) do
          fulltext params[:search_query], :fields => [:media_webcaption, :media_printcaption, :media_originalcaption, :story_category_name, :story_subcategory_name]
          # Filter out any images marked as NotForSale
          without(:forsale, "NotForSale") 
          
          any do  # filter for images For Sale OR (caption and priority)
            all do
              #Filter all searches by location
              with(:story_location_id, default_settings.location_id)
              # Filter all searches by caption text set within default_settings, ie. contains 'Bulletin'
              fulltext default_settings.search_for_caption_text, :fields => [:media_webcaption, :media_printcaption, :media_originalcaption]
              # Filter all searches by priority set within default_settings, ie. contains 'Web Ready'
              fulltext default_settings.search_for_priority, :fields => [:priority]
            end
            fulltext "For Sale", :fields => [:forsale]
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
    default_settings = DefaultSetting.where("location_id" => current_location).first
    @default_settings = DefaultSetting.where("location_id" => current_location).first
    
    @story_image = StoryImage.find_by_media_id(params[:id])
    if @story_image.present?
      # Check whether image is for sale
      if !image_for_sale?(@story_image,default_settings,true)
        if admin?
          flash_message :admin_error, "Image ##{params[:id]} not for sale: Admin only"
        else
          flash_message :notice, "Image ##{params[:id]} not available 
            <a href='mailto:webmaster@wescompapers.com?subject=WescomPhotos.com - Image Request for ##{params[:id]}'>
              <i>- Email us a request for this image</i>
            </a>"
      	  redirect_to story_images_path(:search_query => @story_image.story.categoryname)
      	end
      end
      
      # find other related images
      if @story_image.story.present?
        params[:search_query] = @story_image.story.categoryname
        
        @related_story_images = @story_image.story.story_images.where("id != ?", @story_image.id)         # remove current image
        @related_story_images = @related_story_images.reject {|x| !image_for_sale?(x,default_settings,false)}   # remove any images not for sale
      end

      # find pdfs of this image's publication
      if @story_image.story.present? and @story_image.story.plan.present?
        @pdf_images = PdfImage.includes('plan').where(:pubdate=>@story_image.story.pubdate)
        @pdf_images = @pdf_images.where('plans.pub_name = ?', @story_image.story.plan.pub_name)
        @pdf_images = @pdf_images.order_by_pubdate_sectionletter_page.first(1)
      end
      
    else
      # image doesnt exist in database
      flash_message :notice, "Image ##{params[:id]} not available 
        <a href='mailto:webmaster@wescompapers.com?subject=WescomPhotos.com - Image Request for ##{params[:id]}'>
          <i>- Email us a request for this image</i>
        </a>"
  	  redirect_to root_path
  	end 	
  end

  def approve_forsale
    # Default = null, For Sale = 'For Sale', Not For Sale = 'NotForSale'
    @story_image = StoryImage.find(params[:story_image_id])
    if @story_image.present?
      @story_image.forsale = params[:forsale]
      if @story_image.save
        Log.create_log("Story_image",@story_image.id,@story_image.forsale.to_s,"Image changed to "+@story_image.forsale.to_s,current_user)
      end
      redirect_to story_image_path(@story_image.media_id)
    end
  end
  
  
  private
  def image_for_sale?(image,default_settings,show_errors)
#    default_settings = DefaultSetting.where("location_id" => current_location).first

    # Check captions for default_settings.search_for_caption_text
    caption_text = image.media_webcaption.to_s + image.media_printcaption.to_s + image.media_originalcaption.to_s
    if default_settings.search_for_caption_text.empty? or (caption_text.downcase.include? default_settings.search_for_caption_text.to_s.downcase)
      caption_text_okay = true
    else
      caption_text_okay = false
      flash_message :admin_error, "Caption text '"+default_settings.search_for_caption_text+"' missing" if show_errors
    end
      
    # Check image priority for default_settings.search_for_priority
    if default_settings.search_for_priority.empty? 
      image_priority_okay = true
    else
      if image.priority.nil?
        image_priority_okay = false
        flash_message :admin_error, "Priority = NULL" if show_errors
      else
        if default_settings.search_for_priority.include? image.priority
          image_priority_okay = true
        else
          image_priority_okay = false
          flash_message :admin_error, "Priority = "+image.priority if show_errors
        end
      end
    end
      
    # Return TRUE if image is flagged "For Sale' or is available for sale based on default settings
    if image.forsale.nil?
      if (caption_text_okay and image_priority_okay)
        return true
      else
        return false
      end
    else
      if (image.forsale.include? "For Sale")
        return true
      else
        if (image.forsale.include? "NotForSale")
          return false
        else
          return false
        end
      end
    end
  end
  
end
