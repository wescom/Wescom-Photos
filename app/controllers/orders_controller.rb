class OrdersController < ApplicationController
  before_action :require_admin, only: [:index, :dashboard]

  def dashboard
    @default_settings = DefaultSetting.where("location_id" => current_location).first
    @orders = Order.all
    @order_items = OrderItem.all
  end

  def index
    @default_settings = DefaultSetting.where("location_id" => current_location).first
    @orders = Order.all.order("created_at desc")
    @orders = @orders.where("created_at >= ?", Date.strptime(params[:date_from_select], "%m/%d/%Y")) if params[:date_from_select].present?
    @orders = @orders.where("created_at <= ?", Date.strptime(params[:date_to_select], "%m/%d/%Y")) if params[:date_to_select].present?
    if params[:search].present?
      @orders = @orders.where("id LIKE ? or first_name LIKE ? or last_name LIKE ?", 
        "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    end
    @orders = @orders.where(:success => true)
    @orders = @orders.paginate(:page => params[:page], :per_page => 20)
  end

  def new
    @default_settings = DefaultSetting.where("location_id" => current_location).first

    @order = Order.new
    @cart = Cart.find(session[:cart_id])
    @order.amount = @cart.total
    @order.expiration_month = Date.today.month.to_s
  end

  def create
    @default_settings = DefaultSetting.where("location_id" => current_location).first

    @order = Order.new(order_params)
    @cart = Cart.find(session[:cart_id])
    @order.amount = @cart.total

    ip_address = request.remote_ip
    #Rails.logger.info "*****IP****"+ip_address

    if @order.save
      if @order.amount > 0
        if @order.purchase(@cart,current_location_name)
          # puts "*****ORDER****"+@order.inspect
          Rails.logger.info "*****ORDER SUCCESS****"+@order.inspect
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
            @order_item.item_quality = item.item_quality
            @order_item.item_description = item.item_description
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
        # No cost for items in cart
        @order.success = true
        @order.save
        # Save contents of cart into Order for historical archive
        @cart.cart_items.each do |item|
          @order_item = OrderItem.new(:order_id => @order.id)
          @order_item.item_id = item.item_id
          @order_item.item_type = item.item_type
          @order_item.quantity = item.quantity
          @order_item.price_cents = item.price_cents
          @order_item.price_currency = item.price_currency
          @order_item.item_quality = item.item_quality
          @order_item.item_description = item.item_description
          @order_item.save
        end
        @cart.clear
        flash_message :notice, "Order successful"
        if @order.email.nil? or @order.email.length < 1
          puts "No confirmation email requested"
        else
          OrderMailer.order_confirmation(@order).deliver_now
          flash_message :notice, "Order confirmation email sent"
        end
        redirect_to order_path(@order)
      end
    else
      render :new
    end
  end
    
  def show
    @default_settings = DefaultSetting.where("location_id" => current_location).first
    @order = Order.find_by_obscure_uniq_identifier(params[:id])
  end
  
  def download
    @default_settings = DefaultSetting.where("location_id" => current_location).first

    # Find item to download within the order
    @order = Order.find_by_obscure_uniq_identifier(params[:order_id])
    @order_item = OrderItem.find_by_order_id_and_item_id(@order.id,params[:order_item_id])
    if @order_item.item_type == "StoryImage"
      @image = StoryImage.find(@order_item.item_id)

      @modified_image = MiniMagick::Image.open(@image.image.path)
      @modified_image.strip                 # Strip out all extra image data

      # Write web caption to image's exif data
      pic = MiniExiftool.new @modified_image.path
      pic.caption_abstract = @image.media_webcaption+"\n\n"+"© Western Communications, Inc."+"\n\n"+"Image use license: "+@default_settings.image_use_license.gsub(/<[^>]*>/,'')
      pic.save

      if @order_item.item_quality == "Hires"
        send_file @modified_image.  path, :filename => "image_"+@image.id.to_s+".jpg"
        Rails.logger.info "***** HiRes Image Downloaded ***** " + @image.image.path
      else
        @modified_image.resize "1400x1400"    # Resize image, reducing quality to low resolution
        send_file @modified_image.path, :filename => "image_"+@image.id.to_s+".jpg"
        Rails.logger.info "***** LowRes Image Downloaded ***** " + @image.image.path
      end
    else
      @pdf = PdfImage.find(@order_item.item_id)
      send_file @pdf.image.path, :filename => "PDFpage_"+@pdf.id.to_s+".pdf"
      Rails.logger.info "***** News Page Downloaded ***** " + @pdf.image.path
    end
  end

  def admin_download
    @default_settings = DefaultSetting.where("location_id" => current_location).first

    # Downloads HiRes Original file
    if params[:item_type] == "StoryImage"
      @image = StoryImage.find(params[:order_id])

      @modified_image = MiniMagick::Image.open(@image.image.path)
      @modified_image.strip     # Strip out all extra image data

      # Write web caption to image's exif data
      pic = MiniExiftool.new @modified_image.path
      pic.caption_abstract = @image.media_webcaption+"\n\n"+"© Western Communications, Inc."+"\n\n"+"Image use license: "+@default_settings.image_use_license.gsub(/<[^>]*>/,'')
      pic.save

      send_file @modified_image.path, :filename => "image_"+@image.id.to_s+".jpg"
      Rails.logger.info "***** Image Downloaded ***** " + @image.image.path
    else
      @pdf = PdfImage.find(params[:order_id])
      send_file @pdf.image.path, :filename => "image_"+@pdf.id.to_s+".pdf"
      Rails.logger.info "***** News Page Downloaded ***** " + @pdf.image.path
    end
  end

private
  def order_params
    params.require(:order).permit(:first_name, :last_name, :credit_card_number, :expiration_month, :expiration_year, :card_security_code, 
    :amount, :email, :terms_of_service, :location_id)
  end
  
end
