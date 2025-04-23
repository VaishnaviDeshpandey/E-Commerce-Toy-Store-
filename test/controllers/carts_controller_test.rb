require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers  # Enables user authentication

  def setup
    @user = User.find_or_create_by!(email: "user@example.com") do |user|
      user.name = "User"
      user.password = "password123"
    end

    @category = Category.find_or_create_by!(name: "Electronics") do |category|
      category.description = "Devices and gadgets"
    end

    @product = Product.create!(
      name: "Laptop",
      description: "High-performance laptop",
      price: 1000,
      stock_quantity: 10,
      category: @category
    )

    sign_in @user, scope: :user  # ✅ Ensure Devise recognizes the user mapping
  end

  ## ✅ Test Viewing Cart
  test "should show cart" do
    get cart_path
    assert_response :success
  end

  ## ✅ Test Adding to Cart
  test "should add product to cart" do
    post add_to_cart_cart_path(product_id: @product.id), params: { quantity: 2 }
    
    assert_redirected_to cart_path
    follow_redirect!
    assert_match "#{@product.name} added to your cart!", response.body

    get cart_path
    assert_equal 2, session[:cart][@product.id.to_s]  # ✅ Use session after a request
  end  

  ## ✅ Test Removing from Cart
  test "should remove product from cart" do
    # Add item to cart before attempting to remove it
    post add_to_cart_cart_path(product_id: @product.id), params: { quantity: 2 }

    delete remove_from_cart_cart_path(product_id: @product.id)

    assert_redirected_to cart_path
    follow_redirect!
    assert_match "#{@product.name} removed from your cart!", response.body

    get cart_path
    assert_nil session[:cart][@product.id.to_s]  # ✅ Ensure product is removed
  end

  ## ✅ Test Updating Cart Quantity
  test "should update product quantity in cart" do
    # Add item to cart before updating its quantity
    post add_to_cart_cart_path(product_id: @product.id), params: { quantity: 2 }

    patch update_cart_cart_path(product_id: @product.id), params: { quantity: 5 }

    assert_redirected_to cart_path
    follow_redirect!
    assert_match "#{@product.name} quantity updated!", response.body

    get cart_path
    assert_equal 5, session[:cart][@product.id.to_s]  # ✅ Ensure update worked
  end
end

