class DefaultBannerImagesController < ApplicationController
  before_filter :require_admin

  def new
    @default_banner_image = DefaultBannerImage.new
    @default_setting = DefaultSetting.find(params[:current_default_setting])
  end

  def create
    if params[:cancel_button]
      redirect_to default_settings_path
    else
      @default_banner_image = DefaultBannerImage.new(default_banner_image_params)
      if (!@default_banner_image.nil? && @default_banner_image.save)
        flash_message :notice, "Banner Image Uploaded"
        redirect_to default_settings_url
      else
        flash_message :notice, "Image Failed to Upload"
        render :action => :new
      end
    end    
  end

  def destroy
    @default_banner_image = DefaultBannerImage.find(params[:id])
    if @default_banner_image.destroy
      flash_message :notice, "Banner Image Removed"
      redirect_to default_settings_url
    else
      flash_message :notice, "Image Removal Failed"
      redirect_to default_settings_url
    end
  end

  private
    def default_banner_image_params
      params.require(:default_banner_image).permit(:banner_image,:default_setting_id)
    end

end
