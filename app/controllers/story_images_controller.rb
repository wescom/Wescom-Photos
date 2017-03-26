class StoryImagesController < ApplicationController

  def index
    if params[:search_query]
      begin
        @story_images = StoryImage.search(:include => [:story]) do
          all do
            fulltext params[:search_query]
            any do
              fulltext 'Bulletin', :fields => :media_webcaption
              fulltext 'Bulletin', :fields => :media_printcaption
              fulltext 'Bulletin', :fields => :media_originalcaption
            end
            any_of do
              with(:publish_status, 'Published')
              with(:priority, 'Web Ready')
            end
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
    @story_image = StoryImage.find(params[:id])
  end
end
