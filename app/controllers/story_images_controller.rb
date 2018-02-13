class StoryImagesController < ApplicationController

  def index
    default_settings = DefaultSetting.where("location_id" => current_location).first
    @default_settings = DefaultSetting.where("location_id" => current_location).first

    if params[:search_query]
      begin
        @story_images = StoryImage.search(:include => [:story]) do
          fulltext params[:search_query], 
            :fields => [:media_webcaption, 
                        :media_printcaption, 
                        :media_originalcaption,
                        :media_category,
                        :story_category_name, 
                        :story_subcategory_name,
                        :story_pubdate,
                        :story_pubdate_full_year,
                        :story_pubdate_leading_zeros,
                        :story_pubdate_leading_zeros_full_year,
                        :story_pubyear,
                        :media_name]
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
    else
      redirect_to :root
    end
    @search_result_count = @story_images.total unless @story_images.nil?
    @total_images_count = StoryImage.count(:all)
  end

  def show
    default_settings = DefaultSetting.where("location_id" => current_location).first
    @default_settings = DefaultSetting.where("location_id" => current_location).first
    
    # Check if media_id and story_id are given as paramters. If so, find the image id
    if params.has_key?(:media_id) && params.has_key?(:story_id)
      if !params[:story_id].empty? && !params[:media_id].empty?
        @story = Story.find_by_doc_id(params[:story_id])
        # Rails.logger.info @story.inspect
        if !@story.nil?
          @story_image = @story.story_images.find_by_media_id(params[:media_id]) unless @story.nil?
          # Rails.logger.info @story_image.inspect
          params[:id] = @story_image.id unless @story_image.nil?
        end
      end
    end
    
    @story_image = StoryImage.find_by_id(params[:id])
    if @story_image.present?
      # Check whether image is for sale
      if !image_for_sale?(@story_image,default_settings,true)
        if admin?
          flash_message :admin_error, "Image ##{params[:id]} not for sale: Admin only"
        else
          params_info = ""
          params_info = "StoryId:#{params[:story_id]}" unless params[:story_id].empty?
          params_info = params_info + " MediaId:#{params[:media_id]}" unless params[:media_id].empty?
          flash_message :notice, "Image not available - " + params_info +
            "<a href='mailto:webmaster@wescompapers.com?subject=WescomPhotos.com - Image Request for #{params_info}'>
              <i>- Email us a request for this image</i>
            </a>"
      	  redirect_to story_images_path(:search_query => @story_image.story.categoryname)
      	end
      end
      
      # find other related images from the story
      if @story_image.story.present?
#        params[:search_query] = @story_image.story.categoryname
        
        @related_story_images = @story_image.story.story_images.where("id != ?", @story_image.id)               # remove current image
        @related_story_images = @related_story_images.reject {|x| !image_for_sale?(x,default_settings,false)}   # remove any images not for sale
      end

      # find other related images from the proper names in the caption
      if @related_story_images.nil? || @related_story_images.count < 10
        @proper_names_in_caption = image_caption_names(@story_image.media_webcaption)  # Get proper names from caption
        if !@proper_names_in_caption.nil?
          # Search images for each 'proper name' within caption fields
          @proper_names_in_caption.each do |name|
            begin
              @related_name_images = StoryImage.search(:include => [:story]) do
                fulltext name, 
                  :fields => [:media_webcaption, 
                              :media_printcaption, 
                              :media_originalcaption]
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
                order_by :story_pubdate, :desc
                order_by :story_publication_name, :asc
              end
            end
            # Add related 'proper name' images to related_story_images
            if !@related_name_images.nil?
              @related_name_images.results[0..6].each do |related_image|
                if related_image.id != @story_image.id  # dont add if current image
                  @related_story_images << related_image unless @related_story_images.include?(related_image) # dont add if already in list
                end
              end
            end
          end
        end
      end
      #puts "***related_story_images***"+@related_story_images.inspect

      # find pdfs of this image's publication
      if @story_image.story.present? and @story_image.story.plan.present?
        @pdf_images = PdfImage.includes('plan').where(:pubdate=>@story_image.story.pubdate)
        @pdf_images = @pdf_images.where('plans.pub_name = ?', @story_image.story.plan.pub_name)
        @pdf_images = @pdf_images.order_by_pubdate_sectionletter_page.first(1)
      end
      
    else
      # image doesnt exist in database
      params_info = ""
      if params.has_key?(:media_id) && params.has_key?(:story_id)
        params_info = "StoryId:##{params[:story_id]}" unless params[:story_id].empty?
        params_info = params_info + " MediaId:##{params[:media_id]}" unless params[:media_id].empty?
      end
      Rails.logger.info "Images does not exist in database - Image Id ##{params[:id]} not available"
      flash_message :notice, "Image not available - " + params_info +
        "<a href='mailto:webmaster@wescompapers.com?subject=WescomPhotos.com - Image Request for #{params_info}'>
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
      redirect_to story_image_path(@story_image.id)
    end
  end
  
  
  private
  def image_for_sale?(image,default_settings,show_errors)
#    default_settings = DefaultSetting.where("location_id" => current_location).first

    # Check whether image is flagged "For Sale' or "NotForSale"
    if !image.forsale.nil? && image.forsale != ""
      if (image.forsale.include? "For Sale")
        return true
      else
        if (image.forsale.include? "NotForSale")
          return false
        else
          return false
        end
      end
    else
      # Check whether image is available for sale based on default settings

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
      
      if (caption_text_okay and image_priority_okay)
        return true
      else
        return false
      end
    end
  end
  
  def image_caption_names(caption) 

caption = "Jarod Opperman / The Bulletin Pro men riders cross the Deschutes River on O.B. Riley Road Sunday afternoon during their second lap of the final stage of the Cascade Cycling Classic."

    if caption
      caption = caption.gsub(/\(.*?\)/, "")     # Exclude text between (). This should exclude any photog name and newspaper source on image.
      caption = caption.gsub(/^(.*[\\\/])/, "")     # Exclude text before slash. This should exclude any photog name in older workflows of sourcing an image.
      
      NAMES_TO_FILTER.each {|x| caption.slice! x }    # Remove any names from caption that match the NAMES_TO_FILTER

      regex = /([A-Z][a-z]*)[\s-]([A-Z][a-z]*)/ # Regex to find all proper first/lastnames
      names = caption.scan(regex)               # Pull proper names from caption into an array
      names.map! { |x| x.join(' ') }            # Join first and last name together

      #puts "****** Proper Names ***** "+names.inspect
    else
      name = ""
    end
    return names
  end
end
