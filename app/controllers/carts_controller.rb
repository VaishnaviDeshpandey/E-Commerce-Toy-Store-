class CartsController < ApplicationController
  before_action :set_product, only: [:add_to_cart, :remove_from_cart, :update_cart]
  before_action :authenticate_user!  # Ensure user is logged in before any cart action

  def show
    cart = current_cart
    @cart_items = cart.map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product # Skip if product is not found
  
      { product: product, quantity: quantity }
    end.compact # Remove nil values
  
    @total_price = total_price
  end
  
  
  # Add a product to the cart
  def add_to_cart
    cart = current_cart # This is the cart hash stored in the session

    # Increment the quantity of the product in the cart, or set it to the requested quantity if it's not already in the cart
    cart[@product.id.to_s] ||= 0
    cart[@product.id.to_s] += params[:quantity].to_i

    # Save the updated cart to the session
    session[:cart] = cart

    redirect_to cart_path, notice: "#{@product.name} added to your cart!"
  end

  # Remove a product from the cart
  def remove_from_cart
    cart = current_cart
    cart.delete(@product.id.to_s) # Remove the product from the cart
    session[:cart] = cart # Save the updated cart to the session

    redirect_to cart_path, notice: "#{@product.name} removed from your cart!"
  end

  # Update the quantity of a product in the cart
  def update_cart
    cart = current_cart
    cart[@product.id.to_s] = params[:quantity].to_i # Update the quantity of the product in the cart
    session[:cart] = cart # Save the updated cart to the session

    redirect_to cart_path, notice: "#{@product.name} quantity updated!"
  end

  def total_price
    @cart_items.sum { |item| item[:product].price * item[:quantity] }
  end  

  private

  # Set the product from the URL params
  
  def set_product
    @product = Product.find_by(id: params[:product_id])  # ✅ Avoids `find` raising an error
    unless @product
      redirect_to cart_path, alert: "Product not found"
    end
  end  

  # Get the current cart (a hash stored in the session)
  def current_cart
    session[:cart] ||= {} # Default to an empty hash if no cart exists in the session
  end
end


