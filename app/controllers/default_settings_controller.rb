class DefaultSettingsController < ApplicationController
  before_filter :require_admin
  
  def dashboard
    
  end

  def index
    if DefaultSetting.exists?
      @default_settings = DefaultSetting.all
      @default_setting = DefaultSetting.first
    else  # If no default settings record, then create one and send user to edit
      @default_setting = DefaultSetting.new
      @default_setting.save
      flash_message :notice, "Default settings have not been set. Please update defaults."
      redirect_to edit_default_setting_url(@default_setting)
    end
  end
  
  def edit
    @default_setting = DefaultSetting.find(params[:id])
    @publication_type = PublicationType.all.order("sort_order")
  end

  def update
    @default_setting = DefaultSetting.find(params[:id])
    if params[:cancel_button]
      redirect_to default_settings_url
    else
      if @default_setting.update_attributes(default_setting_params)
        flash_message :notice, "Settings updated"
        redirect_to default_settings_url
      else
        render :action => :edit
      end
    end
  end
  
  private
    def default_setting_params
      params.require(:default_setting).permit(:image_price, :pdf_price, :confirmation_from_email, 
        :image_use_license, :home_welcome_text, :home_main_images, 
        :home_image_cat1_name, :home_image_cat2_name, :home_image_cat3_name, 
        :home_image_cat1, :home_image_cat2, :home_image_cat3, 
        :home_image_cat1_description, :home_image_cat2_description, :home_image_cat3_description, 
        :search_for_publish_status, :search_for_priority, :search_for_caption_text,
        :search_for_pdf_pubdate, :search_for_pdf_pubtype)
    end
end
