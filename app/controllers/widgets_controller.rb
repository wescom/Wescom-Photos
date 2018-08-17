class WidgetsController < ApplicationController
  layout 'widgets'
  after_action :allow_iframe
  
  def story_images
    # parameters available: 
    #   story_id = story_id
    #   pubdate = publication date MM-DD-YYYY
    #   category = story category or subcategory
    #   quantity = number of story images to show

    @default_settings = DefaultSetting.where("location_id" => current_location).first
    default_settings = @default_settings
    @story_images = StoryImage.limit(100).order_by_pubdate

    # filter by params[:story_id]
    @story_images = @story_images.where('story_id = ?', params[:story_id]) unless params[:story_id].nil? or params[:story_id].empty?

    # filter by params[:pubdate]
    @story_images = @story_images.joins(:story).where('stories.pubdate = ?', fix_date_format(params[:pubdate])) unless params[:pubdate].nil? or params[:pubdate].empty?

    # filter to params[:category]
    @story_images = @story_images.has_story_category_or_subcategory(params[:category]) unless params[:category].nil? or params[:category].empty?

    # filter down any images not for sale
    @story_images = @story_images.all.reject {|x| !image_for_sale?(x,default_settings,false)}

    # filter down to quantity params[:quantity], limit results to maximum of 20
    @story_images = @story_images.first(20)
    @story_images = @story_images.first(params[:quantity].to_i) unless params[:quantity].nil? or params[:quantity].empty?
  end  
  
  def pdf_images
    # parameters available: 
    #   pubname = name of publication
    #   pubdate = publication date MM-DD-YYYY
    #   section = section letter of publication
    #   page = page number
    #   quantity = number of pdf images to show

    @default_settings = DefaultSetting.where("location_id" => current_location).first
    @pdf_images = PdfImage.limit(100)

    # filter by params[:pubname]
    @pdf_images = @pdf_images.joins(:plan).where('plans.pub_name = ?', params[:pubname]) unless params[:pubname].nil? or params[:pubname].empty?

    # filter by params[:pubdate]
    @pdf_images = @pdf_images.where('pubdate = ?', fix_date_format(params[:pubdate])) unless params[:pubdate].nil? or params[:pubdate].empty?

    # filter to params[:section]
    @pdf_images = @pdf_images.where('section_letter = ?', params[:section]) unless params[:section].nil? or params[:section].empty?

    # filter to params[:page]
    @pdf_images = @pdf_images.where('page = ?', params[:page]) unless params[:page].nil? or params[:page].empty?

    # filter by default settings for publication_type
    @pdf_images = @pdf_images.where('publication_type_id IN (?)', @default_settings.search_for_pdf_pubtypeId.split(",").map(&:to_i))

    # filter down to quantity params[:quantity], limit results to maximum of 20
    @pdf_images = @pdf_images.order_by_pubdate_sectionletter_page.first(20)
    @pdf_images = @pdf_images.first(params[:quantity].to_i) unless params[:quantity].nil? or params[:quantity].empty?
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
