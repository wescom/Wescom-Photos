module ApplicationHelper

  def cart_quantity
    if session[:cart_id]
      @cart = Cart.find(session[:cart_id])
      quantity = @cart.total_unique_items
      return quantity.to_s
    else
      return "0"
    end
  end

  def cart_label
    return '<i class="fa fa-shopping-cart"> </i>'.html_safe
  end

  def cart_label_quantity
    if cart_quantity().to_i > 0
      return '<i class="fa fa-shopping-cart"> </i>'.html_safe + " " + cart_quantity()
		else
      return '<i class="fa fa-shopping-cart"> </i>'.html_safe
		end
  end

  def cart_label_quantity_items
    if cart_quantity().to_i > 0
			if cart_quantity().to_i > 1
        return '<i class="fa fa-shopping-cart"> </i>'.html_safe + " " + cart_quantity() + " items"
			else
        return '<i class="fa fa-shopping-cart"> </i>'.html_safe + " " + cart_quantity() + " item"
			end
		else
      return '<i class="fa fa-shopping-cart"> </i>'.html_safe
		end
  end
  
  def cart_total_amount
    if session[:cart_id]
      @cart = Cart.find(session[:cart_id])
      total = @cart.total
      return total
    else
      return 0
    end
  end
  
end
