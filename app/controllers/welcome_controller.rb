class WelcomeController < ApplicationController
  def index
    @sports_image = StoryImage.joins(:story).where('subcategoryname = ?','High School').order('created_date DESC').first
    @events_image = StoryImage.joins(:story).where('subcategoryname = ?','Community Sports').order('created_date DESC').first
    @outdoors_image = StoryImage.joins(:story).where('categoryname = ?','Outdoors').order('created_date DESC').first
    
  end
end
