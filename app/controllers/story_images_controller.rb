class StoryImagesController < ApplicationController
  def index
    @story_images = StoryImage.paginate(:page => params[:page], :per_page => 60)
  end

  def show
    @story_image = StoryImage.find(params[:id])
  end
end
