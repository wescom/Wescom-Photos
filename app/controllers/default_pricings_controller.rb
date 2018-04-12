class DefaultPricingsController < ApplicationController
  before_filter :require_admin

  def new
    @default_setting = DefaultSetting.find(params[:current_default_setting])
    @default_pricing = DefaultPricing.new
  end

  def create
    @default_setting = DefaultSetting.find(params[:default_pricing][:default_setting_id])
    if params[:cancel_button]
      redirect_to @default_setting
    else
      @default_pricing = DefaultPricing.new(default_pricing_params)
      if @default_pricing.save
        flash_message :notice, "New Pricing Option Added"
        redirect_to @default_setting
      else
        flash_message :notice, "Price Option Failed"
        render :action => :new
      end
    end
  end

  def edit
    @default_setting = DefaultSetting.find(params[:current_default_setting])
    @default_pricing = DefaultPricing.find(params[:id])
  end

  def update
    @default_setting = DefaultSetting.find(params[:default_pricing][:default_setting_id])
    @default_pricings = DefaultPricing.find(params[:id])
    if params[:cancel_button]
      redirect_to @default_setting
    else
      if @default_pricings.update_attributes(default_pricing_params)
        flash_message :notice, "Pricing updated"
        redirect_to @default_setting
      else
        flash_message :notice, "Price Option Failed"
        render :action => :edit
      end
    end
  end

  def destroy
    @default_pricing = DefaultPricing.find(params[:id])
    if @default_pricing.destroy
      flash_message :notice, "Price Option Removed"
      redirect_to @default_pricing.default_setting
    else
      flash_message :notice, "Price Option Removal Failed"
      redirect_to @default_pricing.default_setting
    end
  end

  private
    def default_pricing_params
      params.require(:default_pricing).permit(:active,:price_name,:item_type,:price_tooltip,:price_quality,:price_description,:price,:default_setting_id)
    end
end
