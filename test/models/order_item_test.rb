require "test_helper"

class OrderItemTest < ActiveSupport::TestCase
  def setup
    # Destroy old records to prevent duplication errors
    User.destroy_all
    Category.destroy_all
    Product.destroy_all
    Order.destroy_all
    OrderItem.destroy_all

    @user = User.create!(
      name: "Test User",
      email: "testuser_#{SecureRandom.hex(4)}@example.com", # Unique email
      password: "password123"
    )

    @category = Category.create!(
      name: "Electronics_#{SecureRandom.hex(4)}",  # Ensure unique category name
      description: "Gadgets and devices"
    )

    @product = Product.create!(
      name: "Laptop_#{SecureRandom.hex(4)}",  # Ensure unique product name
      description: "A high-performance laptop",
      price: 999.99,
      stock_quantity: 10,
      category: @category
    )

    @order = Order.create!(
      user: @user,
      customer_name: "John Doe",
      shipping_address: "123 Test Street",
      total_price: 999.99,
      payment_method: "Credit Card",
      payment_status: "Pending",
      status: "Pending"
    )

    @order_item = OrderItem.create!(
      order: @order,
      product: @product
    )
  end

  test "should be valid with all attributes" do
    assert @order_item.valid?
  end

  test "should require an order" do
    @order_item.order = nil
    assert_not @order_item.valid?
  end

  test "should require a product" do
    @order_item.product = nil
    assert_not @order_item.valid?
  end

  test "should filter by product ID" do
    order_item2 = OrderItem.create!(order: @order, product: @product)
    results = OrderItem.filter_by_product(@product.id)
    assert_includes results, @order_item
    assert_includes results, order_item2
  end
end
