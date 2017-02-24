class OrdersController < ApplicationController
  def index
      @orders = Order.all.order("created_at desc")
    end

    def new
      @order = Order.new
      @cart = session[:cart_id]
    end

    def create
      @order = Order.new(order_params)
      @cart = Cart.find(session[:cart_id])
      @order.amount = @cart.total
      
      if @order.save
        if @order.process
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
          redirect_to orders_path, notice: "Credit card been successfully charged." and return
        else
          puts "********** CC Failed"
          render :new
        end
      else
        render :new
      end
    end

  private
    def order_params
      params.require(:order).permit(:first_name, :last_name, :credit_card_number, :expiration_month, :expiration_year, :card_security_code, :amount)
    end
end
