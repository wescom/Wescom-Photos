module StoryImagesHelper
  
  def get_pdf_image(image)
    if image.story.present? and image.story.plan.present?
      @pdf_images = PdfImage.includes('plan').where(:pubdate=>image.story.pubdate)
      @pdf_images = @pdf_images.where('plans.pub_name = ?', image.story.plan.pub_name)
      @pdf_images = @pdf_images.where('plans.import_section_letter = ?', image.story.plan.import_section_letter) unless image.story.plan.import_section_letter.nil?
      @pdf_images = @pdf_images.order_by_pubdate_sectionletter_page.first(1)
    end
  end

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
  
  def image_for_sale?(image,default_settings)
#    default_settings = DefaultSetting.where("location_id" => current_location).first

    # Check captions for default_settings.search_for_caption_text
    caption_text = image.media_webcaption.to_s + image.media_printcaption.to_s + image.media_originalcaption.to_s
    if default_settings.search_for_caption_text.empty? or (caption_text.downcase.include? default_settings.search_for_caption_text.to_s.downcase)
      caption_text_okay = true
    else
      caption_text_okay = false
    end
      
    # Check image priority for default_settings.search_for_priority
    if default_settings.search_for_priority.empty? 
      image_priority_okay = true
    else
      if image.priority.nil?
        image_priority_okay = false
      else
        if default_settings.search_for_priority.include? image.priority
          image_priority_okay = true
        else
          image_priority_okay = false
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
      if (image.forsale.include? "For Sale")
        return true
      else
        if (image.forsale.include? "NotForSale")
          return false
        else
          return false
        end
      end
    end
  end
end
