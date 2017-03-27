class StoryImagesController < ApplicationController

  def index
    default_settings = DefaultSetting.first

    if params[:search_query]
      begin
        @story_images = StoryImage.search(:include => [:story]) do
          all do
            fulltext params[:search_query], :fields => [:media_webcaption, :media_printcaption, :media_originalcaption, :story_category_name, :story_subcategory_name]
            any do  
              # Filter all searches by caption text set within default_settings, ie. contains 'Bulletin'
              fulltext default_settings.search_for_caption_text, :fields => [:media_webcaption, :media_printcaption, :media_originalcaption]
            end
            any_of do  
              # Filter all searches by publish status and priority set within default_settings, ie. contains 'Published' and 'Web Ready'
              if !default_settings.search_for_publish_status.empty?
                with(:publish_status, default_settings.search_for_publish_status)
              end
              if !default_settings.search_for_priority.empty?
                with(:priority, default_settings.search_for_priority)
              end
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
