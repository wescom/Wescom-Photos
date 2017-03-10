module ApplicationHelper

  def admin?
    if !session[:user_id].nil?
      if User.find(session[:user_id]).role == "Admin"
        return true
      else
        return false
      end
      return false
    end
  end
  
  def edit?
    if User.find(session[:user_id]).role == "Edit"
      return true
    else
      return false
    end
  end
  
  def error_messages(object, field)   # ie: error_messages(@object, @object.field)
    if object.present?
      messages = object.errors["#{field}"].map { |msg| content_tag(:p, msg) }.join
      messages.gsub! "<p>", ""
      messages.gsub! "</p>", ""
      if messages.length > 0
        html = <<-HTML
        <span id="text-error">
          <img src = "/images/icons/exclamation.png" alt = "exclamation" /> #{messages}
        </span>
        HTML
        html.html_safe
      end
    end
  end

  def image_price
    settings = AdminOrder.first
    return settings.image_price
  end
  
  def pdf_price
    settings = AdminOrder.first
    return settings.pdf_price
  end
  
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
