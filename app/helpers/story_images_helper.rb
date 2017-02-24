module StoryImagesHelper
  
  def image_in_cart?(image_id)
    if session[:cart_id]
      @cart = Cart.find(session[:cart_id])
      @cart_item = @cart.cart_items.where(:item_id => image_id)
      if @cart_item.count > 0
        return true
      else
        return false
      end
    else
      return false
    end
  end
end
