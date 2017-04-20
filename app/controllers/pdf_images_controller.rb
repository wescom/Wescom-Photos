class PdfImagesController < ApplicationController

  def index
    @locations = Location.all.order("name")
    @section_letters = PdfImage.select('section_letter').where("section_letter is not null and section_letter<>''").uniq

    scope = Plan.select(:pub_name).where("pub_name is not null and pub_name<>''")
    if !(params[:location].nil? or params[:location] == "")
      scope = scope.where(:location_id => params[:location])
    end
    scope = scope.where(:publication_type_id => 5)  # filter to Editorial type only
    @publications = scope.uniq.order('pub_name')

    if params[:search_query]
      begin
        @pdf_images = PdfImage.search do
          paginate(:page => params[:page], :per_page => 18)
          fulltext params[:search_query]
          with(:pdf_image_pub_type_id, [5])   # filter to Editorial type only
          with(:pubdate).greater_than_or_equal_to(Date.strptime(params[:date_select], "%m/%d/%Y")) if params[:date_select].present?
          with(:pubdate).less_than_or_equal_to(Date.strptime(params[:date_select], "%m/%d/%Y")) if params[:date_select].present?
          with(:publication, params[:pub_select]) if params[:pub_select].present?
          with(:section_letter, params[:sectionletter]) if params[:sectionletter].present?
          
          order_by :pubdate, :desc
          order_by :publication, :asc
          order_by :section_letter, :asc
          order_by :page, :asc
          with :pdf_image_location_id, params[:location] if params[:location].present?
      end
      rescue Errno::ECONNREFUSED
        render :text => "Search Server Down\n\n\n It will be back online shortly"
      end
    end
    @search_result_count = @pdf_images.total
  end

end
