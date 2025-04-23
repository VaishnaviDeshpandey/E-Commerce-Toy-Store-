class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :address, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :address, :role])
  end

  helper_method :current_cart

  # Get the current cart from the session
  def current_cart
    session[:cart] ||= {}
  end

  # Add an item to the cart
  def add_to_cart(product_id, quantity)
    cart = current_cart
    if cart[product_id]
      cart[product_id][:quantity] += quantity.to_i
    else
      cart[product_id] = { product_id: product_id, quantity: quantity.to_i }
    end
    session[:cart] = cart
  end


  # Remove an item from the cart
  def remove_from_cart(product_id)
    cart = current_cart
    cart.delete(product_id)
    session[:cart] = cart
  end

  # Update an item's quantity in the cart
  def update_cart(product_id, quantity)
    cart = current_cart
    if cart[product_id]
      cart[product_id][:quantity] = quantity.to_i
    end
    session[:cart] = cart
  end

  # Calculate total price of the cart
  def total_price
    current_cart.reduce(0) do |sum, (product_id, item)|
      product = Product.find(item[:product_id])
      sum + product.price * item[:quantity]
    end
  end
end
