class CartItem < ApplicationRecord
  acts_as_shopping_cart_item_for :cart
end
