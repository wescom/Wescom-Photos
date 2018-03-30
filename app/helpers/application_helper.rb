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
  
  def current_location
    # get subdomain from URL
    current_subdomain = request.subdomains.first.to_s
    puts "****subdomain***"+current_subdomain.to_s

    # find the location associated to the subdomain and return the location record's ID
    @url_location = Location.where('short_url_newspaper_name like ?', current_subdomain)
    if @url_location.empty?
      # subdomain cannot be found in Location table
      @url_location = Location.first
      #puts "*****URL***"+@url_location.id.to_s
      return @url_location.id
    else
      #puts "*****URL***"+@url_location.first.id.to_s
      return @url_location.first.id
    end
  end

  def current_location_name
    # get subdomain from URL
    current_subdomain = request.subdomains.first.to_s
    puts "****subdomain***"+current_subdomain.to_s

    # find the location associated to the subdomain and return the location record's ID
    @url_location = Location.where('short_url_newspaper_name like ?', current_subdomain)
    if @url_location.empty?
      # subdomain cannot be found in Location table
      @url_location = Location.first
      #puts "*****URL***"+@url_location.id.to_s
      return @url_location.name
    else
      #puts "*****URL***"+@url_location.first.id.to_s
      return @url_location.first.name
    end
  end

  def flash_message(name, msg)
      flash[name] ||= []
      flash[name] << msg
  end

  def image_price
    default_settings = DefaultSetting.where("location_id" => current_location).first
    return default_settings.image_price
  end
  
  def pdf_price
    default_settings = DefaultSetting.where("location_id" => current_location).first
    return default_settings.pdf_price
  end
  
  def cart_quantity
    if session[:cart_id]
      #puts "********** " + session[:cart_id].to_s
      #@cart = session[:cart_id] ? Cart.find(cart_id) : Cart.create
      @cart = Cart.find(session[:cart_id])
      quantity = @cart.total_unique_items
      return quantity.to_s
    else
      return "0"
    end
  rescue StandardError => e
    @_request.reset_session
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
