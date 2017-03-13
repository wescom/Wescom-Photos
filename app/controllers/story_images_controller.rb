class StoryImagesController < ApplicationController

  def index
    @locations = Location.all.order('name')
    @pub_types = PublicationType.all.order('sort_order')

    @publications = Plan.where("pub_name is not null and pub_name<>''")
    @publications = @publications.where(:location_id => params[:location]) if params[:location].present?
    @publications = @publications.where(:publication_type_id => params[:pub_type]) if params[:pub_type].present?
    @publications = @publications.select(:pub_name).distinct.order('pub_name')

    @sections = Plan.where("section_name is not null and section_name<>''")
    @sections = @sections.where(:location_id => params[:location]) if params[:location].present?
    @sections = @sections.where(:publication_type_id => params[:pub_type]) if params[:pub_type].present?
    @sections = @sections.where(:pub_name => params[:pub_select]) if params[:pub_select].present?
    @sections = @sections.select(:section_name).distinct.order('section_name')

    if params[:search_query]
      begin
        @story_images = StoryImage.search(:include => [:story]) do
          fulltext params[:search_query]
          any_of do
            with :story_location_id, params[:location] if params[:location].present?
            with :story_publication_name, params[:pub_select] if params[:pub_select].present?
            with :story_section_name, params[:section_select] if params[:section_select].present?
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
