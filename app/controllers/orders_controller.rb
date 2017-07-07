class OrdersController < ApplicationController
  before_action :require_admin, only: [:index]

  def index
    @orders = Order.all.order("created_at desc")
    if params[:search].present?
      @orders = @orders.where("id = ? or first_name = ? or last_name = ?", params[:search], params[:search], params[:search])
    end
#    @orders = @orders.where(:success => true)
    @orders = @orders.paginate(:page => params[:page], :per_page => 20)
  end

  def new
    @order = Order.new
    @cart = session[:cart_id]
    @order.expiration_month = Date.today.month.to_s

    @default_settings = DefaultSetting.first
  end

  def create
    @default_settings = DefaultSetting.first

    @order = Order.new(order_params)
    @cart = Cart.find(session[:cart_id])
    @order.amount = @cart.total

    # @order = current_cart.build_order(params[:order])
    # @order.ip_address = request.remote_ip
    ip_address = request.remote_ip
Rails.logger.info "*****IP****"+ip_address
    if @order.save
      if @order.purchase
        # puts "*****ORDER****"+@order.inspect
        @order.last4 = @order.credit_card_number.last(4)
        @order.save
        # Save contents of cart into Order for historical archive
        @cart.cart_items.each do |item|
          @order_item = OrderItem.new(:order_id => @order.id)
          @order_item.item_id = item.item_id
          @order_item.item_type = item.item_type
          @order_item.quantity = item.quantity
          @order_item.price_cents = item.price_cents
          @order_item.price_currency = item.price_currency
          @order_item.save
          #puts @order_item.inspect
        end
        @cart.clear
        flash_message :notice, "Credit card successfully charged"
        if @order.email.nil? or @order.email.length < 1
          puts "No confirmation email requested"
        else
          OrderMailer.order_confirmation(@order).deliver_now
          flash_message :notice, "Order confirmation email sent"
        end
        redirect_to order_path(@order)
      else
        Rails.logger.info "********** CC Failed"
        flash_message :error, "Credit card authorization failed"
        render :new
      end
    else
      render :new
    end
  end
    
  def show
    @order = Order.find_by_obscure_uniq_identifier(params[:id])
  end
  
  def download
    if params[:item_type] == "StoryImage"
      @image = StoryImage.find(params[:order_id])
      send_file @image.image.path, :filename => "image_"+@image.id.to_s
      Rails.logger.info "***** Image Downloaded ***** " + @image.image.path
    else
      @pdf = PdfImage.find(params[:order_id])
      send_file @pdf.image.path, :filename => "image_"+@pdf.id.to_s
      Rails.logger.info "***** News Page Downloaded ***** " + @pdf.image.path
    end
  end

private
  def order_params
    params.require(:order).permit(:first_name, :last_name, :credit_card_number, :expiration_month, :expiration_year, :card_security_code, :amount, :email)
  end
  
end
