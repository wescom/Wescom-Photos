class OrdersController < ApplicationController
  before_filter :require_admin, :except => [:show, :download]

  def index
    @orders = Order.all.order("created_at desc")
    if params[:search].present?
      @orders = @orders.where("id = ? or first_name = ? or last_name = ?", params[:search], params[:search], params[:search])
    end
    @orders = @orders.where(:success => true)
    @orders = @orders.paginate(:page => params[:page], :per_page => 20)
  end

  def new
    @order = Order.new
    @cart = session[:cart_id]
    @order.expiration_month = Date.today.month.to_s
  end

  def create
    @order = Order.new(order_params)
    @cart = Cart.find(session[:cart_id])
    @order.amount = @cart.total

    if @order.save
      if @order.process
        @order.last4 = @order.credit_card_number.last(4)
        @order.save
        # Save contents of cart into Order for historical archive
        @cart.cart_items.each do |item|
          @order_item = OrderItem.new(:order_id => @order.id)
          @order_item.item_id = item.item_id
          @order_item.quantity = item.quantity
          @order_item.price_cents = item.price_cents
          @order_item.price_currency = item.price_currency
          @order_item.save
          puts @order_item.inspect
        end
        @cart.clear
        if @order.email.nil?
          puts "No confirmation email requested"
        else
          OrderMailer.order_confirmation(@order).deliver_now
          flash[:notice] = "Order confirmation email sent"
        end
        redirect_to order_path(@order), notice: "Credit card been successfully charged." and return
      else
        puts "********** CC Failed"
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
    @image = StoryImage.find(params[:order_id])
    send_file @image.image.path, :filename => "image_"+@image.id.to_s
    puts "***** Image Downloaded ***** " + @image.image.path
  end

private
  def order_params
    params.require(:order).permit(:first_name, :last_name, :credit_card_number, :expiration_month, :expiration_year, :card_security_code, :amount, :email)
  end
  
end
