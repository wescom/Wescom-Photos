class CartsController < ApplicationController
  before_filter :extract_cart

  def create
    @story_image = StoryImage.find(params[:id])
    @cart_item = CartItem.where(:item_id => @story_image.id)
    # Check whether item is already in cart
    if @cart_item.exists?
      flash[:notice] = "Image already in cart"
    else
      @cart.add(@story_image, 1)
    end
    redirect_to cart_path
  end

  def show

  end
  
  def remove_item
    # remove item from cart
    @cart.remove(params[:id], 1)
    flash[:notice] = "Image removed"
    redirect_to cart_path
  end

  private
  def extract_cart
    cart_id = session[:cart_id]
    @cart = session[:cart_id] ? Cart.find(cart_id) : Cart.create
    session[:cart_id] = @cart.id
  end
end