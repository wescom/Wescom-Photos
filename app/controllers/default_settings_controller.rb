class DefaultSettingsController < ApplicationController
  before_filter :require_admin
  
  def index
    @default_settings = DefaultSetting.where("location_id" => current_location).first
    @locations = Location.all.order("name")
    
    if DefaultSetting.exists?
      @all_default_settings = DefaultSetting.all
    else  # If no default settings record, then create one and send user to edit
      @default_settings = DefaultSetting.new
      @default_settings.save
      flash_message :notice, "Default settings have not been set. Please update defaults."
      redirect_to edit_default_setting_url(@default_settings)
    end
  end
  
  def new
    @locations = Location.all.order("name")
    @publication_type = PublicationType.all.order("sort_order")
    params[:search_for_pdf_pubtypeId_array] = "1"
    
    @default_settings = DefaultSetting.new
  end
  
  def create
    @locations = Location.all.order("name")
    
    if params[:cancel_button]
      redirect_to default_settings_url
    else
      @default_settings = DefaultSetting.new(default_setting_params)
      if @default_settings.save
        flash_message :notice, "Default Settings Created"
        redirect_to default_settings_url
      else
        render :action => :new
      end
    end
  end
  
  def edit
    @locations = Location.all.order("name")
    @publication_type = PublicationType.all.order("sort_order")
    params[:search_for_pdf_pubtypeId_array] = ""
    
    @default_settings = DefaultSetting.find(params[:id])
  end

  def update
    @locations = Location.all.order("name")
    
    @default_settings = DefaultSetting.find(params[:id])
    if params[:cancel_button]
      redirect_to default_settings_url
    else
      if @default_settings.update_attributes(default_setting_params)
        flash_message :notice, "Settings updated"
        redirect_to default_settings_url
      else
        render :action => :edit
      end
    end
  end
  
  def show
    @locations = Location.all.order("name")
    @default_settings = DefaultSetting.find(params[:id])    
  end
  
  private
    def default_setting_params
      # convert search_for_pdf_pubtypeId from array to string, removing blanks
      params["default_setting"]["search_for_pdf_pubtypeId"] = params["default_setting"]["search_for_pdf_pubtypeId"].reject { |e| e.to_s.empty? }
      params["default_setting"]["search_for_pdf_pubtypeId"] = params["default_setting"]["search_for_pdf_pubtypeId"].join(",")
      
      params.require(:default_setting).permit(:image_price, :image_hi_res_price, :image_low_res_price, :pdf_price, :confirmation_from_email, 
        :image_use_license, :home_welcome_text, :home_main_images, 
        :home_image_cat1_name, :home_image_cat2_name, :home_image_cat3_name, 
        :home_image_cat1, :home_image_cat2, :home_image_cat3, 
        :home_image_cat1_description, :home_image_cat2_description, :home_image_cat3_description, 
        :search_for_publish_status, :search_for_priority, :search_for_caption_text,
        :search_for_pdf_pubdate, :search_for_pdf_pubtypeId, :location_id, :site_image)
    end
end
