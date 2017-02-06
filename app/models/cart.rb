class Cart < ApplicationRecord
  acts_as_shopping_cart_using :cart_item
  
  # Override with your own tax calculation
    #
    # def taxes
    #   subtotal * 8.3
    # end
    #
    # Or...
    #
    # Override this one with a percentage
  def tax_pct
    0.00
  end

    #
    # Override with shipping cost calculation
    #
    # def shipping_cost
    #   5
    # end
end
