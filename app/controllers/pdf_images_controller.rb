class PdfImagesController < ApplicationController

  def index
    default_settings = DefaultSetting.where("location_id" => current_location).first
    @locations = Location.all.order("name")

    @plans = Plan.where("location_id" => current_location)
    @plans = @plans.where('publication_type_id IN (?)', default_settings.search_for_pdf_pubtypeId.split(",").map(&:to_i))
    @publications = @plans.select(:pub_name).joins(:pdf_images).uniq.order(:pub_name)
    @section_letters = @plans.select("pdf_images.section_letter").joins(:pdf_images).uniq.order("pdf_images.section_letter")

    if params[:search_query]
      begin
        @pdf_images = PdfImage.search do
          paginate(:page => params[:page], :per_page => 18)
          fulltext params[:search_query]
          
          # Filter by location and pub type
          with(:pdf_image_location_id, default_settings.location_id)
          with(:pdf_image_pub_type_id, default_settings.search_for_pdf_pubtypeId.split(",").map(&:to_i)) if default_settings.search_for_pdf_pubtypeId.present?

          # Filter by params
          with(:pubdate).greater_than_or_equal_to(Date.strptime(params[:date_select], "%m/%d/%Y")) if params[:date_select].present?
          with(:pubdate).less_than_or_equal_to(Date.strptime(params[:date_select], "%m/%d/%Y")) if params[:date_select].present?
          with(:pdf_plan_publication, params[:pub_select]) if params[:pub_select].present?
          with(:section_letter, params[:sectionletter]) if params[:sectionletter].present?

          # Exclue anything older than specified pubdate
          with(:pubdate).greater_than_or_equal_to(Date.strptime(default_settings.search_for_pdf_pubdate, "%m/%d/%Y")) unless default_settings.search_for_pdf_pubdate.empty?
          
          order_by :pubdate, :desc
          order_by :publication, :asc
          order_by :section_letter, :asc
          order_by :page, :asc
      end
      rescue Errno::ECONNREFUSED
        render :text => "Search Server Down\n\n\n It will be back online shortly"
      end
    end
    @search_result_count = @pdf_images.total
  end

end
