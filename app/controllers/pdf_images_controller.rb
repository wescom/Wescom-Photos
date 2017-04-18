class PdfImagesController < ApplicationController

  def index
    @locations = Location.all.order("location_no")

    if params[:search_query]
      begin
        @pdf_images = PdfImage.search do
          paginate(:page => params[:page], :per_page => 18)
          fulltext params[:search_query]
          with(:pdf_image_pub_type_id, [1, 4, 5])
          
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
