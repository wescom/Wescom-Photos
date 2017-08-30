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
  
  def image_for_sale?(image)
    default_settings = DefaultSetting.first

    # Check captions for default_settings.search_for_caption_text
    caption_text = image.media_webcaption.to_s + image.media_printcaption.to_s + image.media_originalcaption.to_s
    if default_settings.search_for_caption_text.nil? or (caption_text.downcase.include? default_settings.search_for_caption_text.to_s.downcase)
      caption_text_okay = true
    else
      caption_text_okay = false
    end
      
    # Check image priority for default_settings.search_for_priority
    if default_settings.search_for_priority.nil? 
      image_priority_okay = true
    else
      if image.priority.nil?
        image_priority_okay = false
        flash_message :admin_error, "Priority = NULL"
      else
        if default_settings.search_for_priority.include? image.priority
          image_priority_okay = true
        else
          image_priority_okay = false
          flash_message :admin_error, "Priority = "+image.priority
        end
      end
    end
      
    # Return TRUE if image is flagged "For Sale' or is available for sale based on default settings
    if image.forsale.nil?
      if (caption_text_okay and image_priority_okay)
        return true
      else
        return false
      end
    else
      if (image.forsale.include? "For Sale") or (caption_text_okay and image_priority_okay)
        return true
      else
        return false
      end
    end
  end
end
