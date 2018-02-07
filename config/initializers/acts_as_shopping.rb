ActiveRecord::Acts::ShoppingCart::Collection.class_eval do
  def add(object, price, quantity = 1, cumulative = true, quality, description)
    cart_item = item_for(object)

    if cart_item
      cumulative = cumulative == true ? cart_item.quantity : 0
      cart_item.quantity = (cumulative + quantity)
      
      # Save extra info of image being added to cart
      cart_item.quality = params[:quality] if params[:quality].exists?
      cart_item.description = params[:description] if params[:description].exists?
      
      cart_item.save
      cart_item
    else
      shopping_cart_items.create(item: object, price: price, quantity: quantity, item_quality: quality, item_description: description)
    end
  end
end