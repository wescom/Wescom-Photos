class DefaultSettingsController < ApplicationController
  before_filter :require_admin
  
  def dashboard
    
  end

  def index
    @default_settings = DefaultSetting.all
    @default_setting = DefaultSetting.first
  end
  
  def edit
    @default_setting = DefaultSetting.find(params[:id])
  end

  def update
    @default_setting = DefaultSetting.find(params[:id])
    if params[:cancel_button]
      redirect_to default_settings_url
    else
      if @default_setting.update_attributes(default_setting_params)
        flash[:notice] = "Settings updated"
        redirect_to default_settings_url
      else
        render :action => :edit
      end
    end
  end
  
  private
    def default_setting_params
      params.require(:default_setting).permit(:image_price, :pdf_price, :confirmation_from_email, 
        :image_use_license, :home_welcome_text, :home_image_cat1_name, :home_image_cat2_name, :home_image_cat3_name, 
        :home_image_cat1, :home_image_cat2, :home_image_cat3)
    end
end
