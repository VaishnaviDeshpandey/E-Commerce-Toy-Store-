class CartItem < ApplicationRecord
    # Association with Product
    belongs_to :product
    # belongs_to :user, optional: true # Only if you're tracking users
  
    # Validation for quantity
    validates :quantity, numericality: { greater_than_or_equal_to: 1 }
  
    # Total price for this cart item
    def total_price
      product.price * quantity
    end
end
  
