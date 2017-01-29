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
          paginate(:page => params[:page], :per_page => 15)
          fulltext params[:search_query]
          order_by :story_pubdate, :desc
          order_by :story_publication_name, :asc
          order_by :story_section_name, :asc
          order_by :story_page, :asc
          with(:story_pubdate).greater_than_or_equal_to(params[:date_from_select]) if params[:date_from_select].present?
          with(:story_pubdate).less_than_or_equal_to(params[:date_to_select]) if params[:date_to_select].present?
          with :image_type, params[:image_type] if params[:image_type].present?
          with :story_location_id, params[:location] if params[:location].present?
          with :story_pub_type_id, params[:pub_type] if params[:pub_type].present?
          with :story_publication_name, params[:pub_select] if params[:pub_select].present?
          with :story_section_name, params[:section_select] if params[:section_select].present?
      end
      rescue Errno::ECONNREFUSED
        render :text => "Search Server Down\n\n\n It will be back online shortly"
      end
    end
    @search_results = @story_images.results
    @total_images_count = StoryImage.count(:all)
  end

  def show
    @story_image = StoryImage.find(params[:id])
  end
end
