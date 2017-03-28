class HomeController < ApplicationController
  def index
    if DefaultSetting.exists? 
      @default_settings = DefaultSetting.first

      # Get random image from home_main_images for display on Home page
      random_image = @default_settings.home_main_images.split(/\s*,\s*/).shuffle.first
      @main_image = StoryImage.find(random_image)

      # Get sample image category info
      @cat1_image = StoryImage.joins(:story)
      @cat1_image = @cat1_image.published.where('categoryname = ? OR subcategoryname = ?',@default_settings.home_image_cat1, @default_settings.home_image_cat1)
      @cat1_image = @cat1_image.where('media_webcaption like ?',"%#{@default_settings.search_for_caption_text}%")
      @cat1_image = @cat1_image.order_by_pubdate.first

      @cat2_image = StoryImage.joins(:story)
      @cat2_image = @cat2_image.published.where('categoryname = ? OR subcategoryname = ?',@default_settings.home_image_cat2, @default_settings.home_image_cat2)
      @cat2_image = @cat2_image.where('media_webcaption like ?',"%#{@default_settings.search_for_caption_text}%")
      @cat2_image = @cat2_image.order_by_pubdate.first

      @cat3_image = StoryImage.joins(:story)
      @cat3_image = @cat3_image.published.where('categoryname = ? OR subcategoryname = ?',@default_settings.home_image_cat3, @default_settings.home_image_cat3)
      @cat3_image = @cat3_image.where('media_webcaption like ?',"%#{@default_settings.search_for_caption_text}%")
      @cat3_image = @cat3_image.order_by_pubdate.first

    else  # If no default settings record, then create one and send user to edit
      @default_setting = DefaultSetting.new
      @default_setting.save
      flash[:notice] = "Default settings have not been set. Please update defaults."
      redirect_to edit_default_setting_url(@default_setting)
    end
  end
end
