module ApplicationHelper

  def strip_subhead_tags(text)
    text.html_safe.gsub(/<p class="hl2_chapterhead">/, '<p>')
  end


  def cart_quantity
    @cart = Cart.find(session[:cart_id])
    quantity = @cart.total_unique_items
    return quantity.to_s
  end
end
