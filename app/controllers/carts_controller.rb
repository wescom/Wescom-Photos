class CartsController < ApplicationController
  before_filter :extract_cart

  def create   # Add image item to cart
    @story_image = StoryImage.find(params[:id])
    @cart_item = CartItem.where(:item_id => @story_image.id)
    # Check whether item is already in cart
    if @cart_item.exists?
      flash_message :notice, "Image already in cart"
    else
      @cart.add(@story_image, image_price)
    end
    redirect_to cart_path
  end

  def add_pdf   # Add PDF item to cart
    @pdf_image = PdfImage.find(params[:id])
    @cart_item = CartItem.where(:item_id => @pdf_image.id)
    # Check whether item is already in cart
    if @cart_item.exists?
      flash_message :notice, "News page already in cart"
    else
      @cart.add(@pdf_image, pdf_price)
    end
    redirect_to cart_path
  end

  def show
    if request.url != request.referrer
      # save referring url to retain previous search page
      session[:referrer] = request.referrer
    end

  end
  
  def remove_item
    # remove item from cart
    @cart.remove(params[:id], 1)
    flash_message :notice, "Item removed from cart"
    redirect_to cart_path()
  end

  private
  def extract_cart
    cart_id = session[:cart_id]
    @cart = session[:cart_id] ? Cart.find(cart_id) : Cart.create
    session[:cart_id] = @cart.id
  end
end