class AdminOrdersController < ApplicationController
  before_filter :require_admin
  
  def dashboard
    
  end

  def index
    @settings = AdminOrder.all
    @setting = AdminOrder.first
  end
  
  def edit
    @admin_order = AdminOrder.find(params[:id])
  end

  def update
    @admin_order = AdminOrder.find(params[:id])
    if params[:cancel_button]
      redirect_to admin_orders_url
    else
      if @admin_order.update_attributes(admin_order_params)
        flash[:notice] = "Settings updated"
        redirect_to admin_orders_url
      else
        render :action => :edit
      end
    end
  end
  
  private
    def admin_order_params
      params.require(:admin_order).permit(:image_price, :pdf_price, :confirmation_email)
    end

end
