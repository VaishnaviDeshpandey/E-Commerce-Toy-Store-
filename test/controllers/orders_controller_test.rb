require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers  # Enables user sign-in

  def setup
    # Create or find a user with Devise mapping
    @user = User.find_or_create_by!(email: "johndoe@example.com") do |user|
      user.name = "John Doe"
      user.password = "password123"
      user.role = "user"
      user.admin = false
    end

    @admin = User.find_or_create_by!(email: "admin@example.com") do |user|
      user.name = "Admin User"
      user.password = "password123"
      user.role = "admin"
      user.admin = true
    end

     # Ensure a category exists before creating a product
    @category = Category.find_or_create_by!(name: "Electronics")

    # Ensure a product exists
    @product = Product.find_or_create_by!(name: "Laptop", category: @category) do |product|
      product.description = "High-performance laptop"
      product.price = 50000
      product.stock_quantity = 10
    end

    # Ensure Devise properly maps user model
    sign_in @user, scope: :user  # ✅ FIX: Explicitly specify Devise scope
  end

  test "should get index for logged-in user" do
    get orders_path
    assert_response :success
  end

  test "should redirect index when not logged in" do
    sign_out @user
    get orders_path
    assert_redirected_to new_user_session_path
  end

  test "should allow user to place an order" do
    assert_not_nil @product, "Product should not be nil"  # Ensure product exists
  
    # ✅ Use the correct path based on your routes
    post add_to_cart_cart_path(@product), params: { quantity: 2 } 
  
    post orders_path, params: { order: { shipping_address: "456 Street", payment_method: "Credit Card" } }
  
    assert_redirected_to thank_you_order_path(Order.last)
    assert_equal "Order placed successfully!", flash[:notice]
  end
  
  

  test "should allow admin to update order" do
    sign_in @admin, scope: :user  # ✅ FIX: Explicitly specify Devise scope
    order = Order.create!(user: @user, shipping_address: "123 Street", customer_name: @user.name, total_price: 100, payment_method: "Credit Card", status: "Pending", payment_status: "Pending")

    patch order_path(order), params: { order: { status: "Shipped" } }
    assert_redirected_to admin_orders_path
    assert_equal "Order updated successfully!", flash[:notice]
    order.reload
    assert_equal "Shipped", order.status
  end

  test "should prevent non-admin from updating order" do
    order = Order.create!(
      user: @user,
      shipping_address: "123 Street",
      customer_name: @user.name,
      total_price: 100,
      payment_method: "Credit Card",
      status: "Pending",
      payment_status: "Pending"
    )
  
    assert_raises(Pundit::NotAuthorizedError) do
      patch order_path(order), params: { order: { status: "Shipped" } }
    end
  end
  

  test "should delete order as admin" do
    sign_in @admin, scope: :user  # ✅ FIX: Explicitly specify Devise scope
    order = Order.create!(user: @user, shipping_address: "123 Street", customer_name: @user.name, total_price: 100, payment_method: "Credit Card", status: "Pending", payment_status: "Pending")

    assert_difference("Order.count", -1) do
      delete order_path(order)
    end
    assert_redirected_to admin_orders_path
    assert_equal "Order deleted successfully!", flash[:notice]
  end
end

