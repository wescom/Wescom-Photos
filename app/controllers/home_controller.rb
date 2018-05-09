class HomeController < ApplicationController
  skip_before_action :check_current_location
  
  def index
    if DefaultSetting.exists?

      if current_location.nil? 
        # No subdomain given in url, so list all locations for user to choose from
        @default_settings_list = DefaultSetting.where('active' => true)
      else
        # Subdomain given in url, so display Home page for that location
        @default_settings = DefaultSetting.where("location_id" => current_location).first

        if @default_settings.nil?
          flash_message :notice, "Default settings have not been set. Please update defaults for location: "+current_location.to_s
          @default_settings = DefaultSetting.first
          redirect_to default_settings_url
        end

        # Get random image from default_banner_images to display on Home page
        if @default_settings.default_banner_images.count > 0
          random_image = @default_settings.default_banner_images.order("RAND()").first
          @banner_image = DefaultBannerImage.find(random_image)
        else
          @main_image = nil
        end

        # Get sample image category info
        @cat1_image = StoryImage.joins(:story).order_by_pubdate.limit(10)
        @cat1_image = @cat1_image.where('media_width > media_height')
        @cat1_image = @cat1_image.where('categoryname = ? OR subcategoryname = ? OR media_category = ?',
          @default_settings.home_image_cat1, @default_settings.home_image_cat1, @default_settings.home_image_cat1)
        @cat1_image = @cat1_image.where('media_webcaption like ?',"%#{@default_settings.search_for_caption_text}%")
        if @cat1_image.count < 1  # Didnt find an image record, query more records
          @cat1_image = StoryImage.joins(:story).order_by_pubdate.limit(100)
          @cat1_image = @cat1_image.where('media_width > media_height')
          @cat1_image = @cat1_image.where('categoryname = ? OR subcategoryname = ? OR media_category = ?',
            @default_settings.home_image_cat1, @default_settings.home_image_cat1, @default_settings.home_image_cat1)
          @cat1_image = @cat1_image.where('media_webcaption like ?',"%#{@default_settings.search_for_caption_text}%")
        end
        @cat1_image = @cat1_image.order_by_pubdate.first

        @cat2_image = StoryImage.joins(:story).order_by_pubdate.limit(10)
        @cat2_image = @cat2_image.where('media_width > media_height')
        @cat2_image = @cat2_image.where('categoryname = ? OR subcategoryname = ? OR media_category = ?',
          @default_settings.home_image_cat2, @default_settings.home_image_cat2, @default_settings.home_image_cat2)
        @cat2_image = @cat2_image.where('media_webcaption like ?',"%#{@default_settings.search_for_caption_text}%")
        if @cat2_image.count < 1  # Didnt find an image record, query more records
          @cat2_image = StoryImage.joins(:story).order_by_pubdate.limit(100)
          @cat2_image = @cat2_image.where('media_width > media_height')
          @cat2_image = @cat2_image.where('categoryname = ? OR subcategoryname = ? OR media_category = ?',
            @default_settings.home_image_cat2, @default_settings.home_image_cat2, @default_settings.home_image_cat2)
          @cat2_image = @cat2_image.where('media_webcaption like ?',"%#{@default_settings.search_for_caption_text}%")
        end
        @cat2_image = @cat2_image.order_by_pubdate.first

        @cat3_image = StoryImage.joins(:story).order_by_pubdate.limit(10)
        @cat3_image = @cat3_image.where('media_width > media_height')
        @cat3_image = @cat3_image.where('categoryname = ? OR subcategoryname = ? OR media_category = ?',
          @default_settings.home_image_cat3, @default_settings.home_image_cat3, @default_settings.home_image_cat3)
        @cat3_image = @cat3_image.where('media_webcaption like ?',"%#{@default_settings.search_for_caption_text}%")
        if @cat3_image.count < 1  # Didnt find an image record, query more records
          @cat3_image = StoryImage.joins(:story).order_by_pubdate.limit(100)
          @cat3_image = @cat3_image.where('media_width > media_height')
          @cat3_image = @cat3_image.where('categoryname = ? OR subcategoryname = ?',@default_settings.home_image_cat3, @default_settings.home_image_cat3)
          @cat3_image = @cat3_image.where('media_webcaption like ?',"%#{@default_settings.search_for_caption_text}%")
        end
        @cat3_image = @cat3_image.order_by_pubdate.first

        @pdf_images = PdfImage.joins(:plan).where('plans.location_id = ?', @default_settings.location_id)
//        if @default_settings.location_id == 1
          @pdf_images = @pdf_images.where('section_letter = ? and page = ?', "A", 1)
//        else 
//          @pdf_images = @pdf_images.where('page = ?', 1)
//        end
        @pdf_images = @pdf_images.order_by_pubdate_sectionletter_page.first(4)
    
        @locations = Location.all.order("location_no")
      end
    else  # If no default settings record, then create one and send user to edit
      @default_settings = DefaultSetting.new
      @default_settings.save
      flash_message :notice, "Default settings have not been set. Please update defaults."
      redirect_to edit_default_setting_url(@default_settings)
    end
  end
end
