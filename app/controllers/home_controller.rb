class HomeController < ApplicationController
  def index
    if DefaultSetting.exists? 
      @default_settings = DefaultSetting.first
    
      @cat1_image = StoryImage.joins(:story).published.where('categoryname = ? OR subcategoryname = ?',@default_settings.home_image_cat1, @default_settings.home_image_cat1).order_by_pubdate.first
      @cat2_image = StoryImage.joins(:story).published.where('categoryname = ? OR subcategoryname = ?',@default_settings.home_image_cat2, @default_settings.home_image_cat2).order_by_pubdate.first
      @cat3_image = StoryImage.joins(:story).published.where('categoryname = ? OR subcategoryname = ?',@default_settings.home_image_cat3, @default_settings.home_image_cat3).order_by_pubdate.first

    else  # If no default settings record, then create one and send user to edit
      @default_setting = DefaultSetting.new
      @default_setting.save
      flash[:notice] = "Default settings have not been set. Please update defaults."
      redirect_to edit_default_setting_url(@default_setting)
    end
  end
end
