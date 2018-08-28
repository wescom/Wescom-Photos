class WidgetsController < ApplicationController
  layout 'widgets'
  after_action :allow_iframe
  
  def index
    render action: "index", layout: "application"
  end
  
  def story_images
    # parameters available: 
    #   search_query = text to search for within image captions
    #   story_id = story_id
    #   pubdate = publication date MM-DD-YYYY
    #   category = image category or story category/subcategory
    #   quantity = number of story images to show

    @default_settings = DefaultSetting.where("location_id" => current_location).first
    default_settings = @default_settings

    params[:search_query] = "" if params[:search_query].nil?
    params[:search_query] = params[:search_query] + " " + params[:pubdate].to_s unless params[:pubdate].nil?
    params[:search_query] = params[:search_query] + " " + params[:category].to_s  unless params[:category].nil?
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
            #filter by params[:story_id]
            #with(:story_id, params[:story_id]) 
            #Filter all searches by location
            with(:story_location_id, default_settings.location_id)
            # Filter all searches by priority set within default_settings, ie. contains 'Web Ready'
            fulltext default_settings.search_for_priority, :fields => [:priority]
            any do  # Filter all searches by caption text set within default_settings, ie. contains 'Bulletin' or 'Spokesman'
              fulltext default_settings.search_for_caption_text, :fields => [:media_webcaption, :media_printcaption, :media_originalcaption]
              fulltext default_settings.search_for_caption_text2, :fields => [:media_webcaption, :media_printcaption, :media_originalcaption]
            end
          end
          fulltext "For Sale", :fields => [:forsale]
        end

        order_by :story_pubdate, :desc
      end
      rescue Errno::ECONNREFUSED
        render :text => "Search Server Down\n\n\n It will be back online shortly"
    end
    @story_images = @story_images.results.first(20) unless @story_images.nil?
    @story_images = @story_images.first(params[:quantity].to_i) unless @story_images.nil? or params[:quantity].nil? or params[:quantity].empty?
  end  
  
  def pdf_images
    # parameters available:
    #   search_query = text to search for within PDF
    #   pubname = name of publication
    #   pubdate = publication date MM-DD-YYYY
    #   section = section letter of publication
    #   page = page number
    #   quantity = number of pdf images to show

    @default_settings = DefaultSetting.where("location_id" => current_location).first
    default_settings = @default_settings

    begin
      @pdf_images = PdfImage.search do
        fulltext params[:search_query] if params[:search_query].present?
        
        # Filter by location and pub type
        with(:pdf_image_location_id, default_settings.location_id)
        with(:pdf_image_pub_type_id, default_settings.search_for_pdf_pubtypeId.split(",").map(&:to_i)) if default_settings.search_for_pdf_pubtypeId.present?

        # Filter by params
        with(:pubdate).greater_than_or_equal_to(fix_date_format(params[:pubdate])) if params[:pubdate].present?
        with(:pubdate).less_than_or_equal_to(fix_date_format(params[:pubdate])) if params[:pubdate].present?
        with(:pdf_plan_publication, params[:pubname]) if params[:pubname].present?
        with(:pdf_plan_section_name, params[:section]) if params[:section].present?
        with(:page, params[:page]) if params[:page].present?

        # Exclue anything older than specified pubdate
        with(:pubdate).greater_than_or_equal_to(Date.strptime(default_settings.search_for_pdf_pubdate, "%m/%d/%Y")) unless default_settings.search_for_pdf_pubdate.empty?
        
        order_by :pubdate, :desc
        order_by :section_letter, :asc
        order_by :page, :asc
    end
    rescue Errno::ECONNREFUSED
      render :text => "Search Server Down\n\n\n It will be back online shortly"
    end
    @pdf_images = @pdf_images.results.first(20) unless @pdf_images.nil?
    @pdf_images = @pdf_images.first(params[:quantity].to_i) unless @pdf_images.nil? or params[:quantity].nil? or params[:quantity].empty?
  end  
  
  
  private
    def allow_iframe
      response.headers.delete "X-Frame-Options"
    end
    
    def fix_date_format(date)
      # takes date and converts it to format YYYY-MM-DD, return nil if date invalid
      if date.nil? or date.empty?
        return nil
      else
        begin
          date = date.gsub("/", "-")
          date = Date.strptime(date, "%m-%d-%Y")
          return date
        rescue Exception
          puts "pubdate param failed"
          return nil
        end
      end
    end
    
    def image_for_sale?(image,default_settings,show_errors)
      # Check if image has story, plan and location
      if image.story.present? and image.story.plan.present? and image.story.plan.location.present?
        if image.story.plan.location != current_location
          # Image is from a different location, switch default_settings filter criteria
          @default_settings = DefaultSetting.where("location_id" => image.story.plan.location.id).first
          default_settings = @default_settings
          if default_settings.nil?
            puts "*** Image ID "+image.id.to_s+" attached to story ID "+image.story.id.to_s+" do not have a valid plan location"
            return false
          end
        end
      end

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

        # Check captions for default_settings.search_for_caption_text or default_settings.search_for_caption_text2
        caption_text = image.media_webcaption.to_s + image.media_printcaption.to_s + image.media_originalcaption.to_s

        if (default_settings.search_for_caption_text.empty? and default_settings.search_for_caption_text2.empty?) or 
          (caption_text.downcase.include? default_settings.search_for_caption_text.to_s.downcase) or 
          (caption_text.downcase.include? default_settings.search_for_caption_text2.to_s.downcase)
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
end
