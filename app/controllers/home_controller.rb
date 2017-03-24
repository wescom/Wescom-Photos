class HomeController < ApplicationController
  def index
    @default_settings = DefaultSetting.first
    
    @cat1_image = StoryImage.joins(:story).where('categoryname = ? OR subcategoryname = ?',@default_settings.home_image_cat1, @default_settings.home_image_cat1).order_by_pubdate.first
    @cat2_image = StoryImage.joins(:story).where('categoryname = ? OR subcategoryname = ?',@default_settings.home_image_cat2, @default_settings.home_image_cat2).order_by_pubdate.first
    @cat3_image = StoryImage.joins(:story).where('categoryname = ? OR subcategoryname = ?',@default_settings.home_image_cat3, @default_settings.home_image_cat3).order_by_pubdate.first
  end
end
