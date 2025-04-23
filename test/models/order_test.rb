require "test_helper"

class OrderTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      name: "Test User",  # Ensure the user has a name
      email: "testuser_#{SecureRandom.hex(4)}@example.com",  # Unique email
      password: "password123"
    )

    @order = Order.new(
      user: @user,
      customer_name: "John Doe",
      shipping_address: "123 Test Street",
      total_price: 100.50,
      payment_method: "Credit Card",
      payment_status: "Pending",
      status: "Pending"
    )
  end

  test "should be valid with all attributes" do
    assert @order.valid?
  end

  test "should require a customer_name" do
    @order.customer_name = nil
    assert_not @order.valid?
    assert_includes @order.errors[:customer_name], "can't be blank"
  end

  test "should require a shipping_address" do
    @order.shipping_address = nil
    assert_not @order.valid?
    assert_includes @order.errors[:shipping_address], "can't be blank"
  end

  test "should require a total_price" do
    @order.total_price = nil
    assert_not @order.valid?
    assert_includes @order.errors[:total_price], "can't be blank"
  end

  test "should require total_price to be positive" do
    @order.total_price = -5
    assert_not @order.valid?
    assert_includes @order.errors[:total_price], "must be greater than or equal to 0.01"
  end

  test "should require a payment_method" do
    @order.payment_method = nil
    assert_not @order.valid?
    assert_includes @order.errors[:payment_method], "can't be blank"
  end

  test "should allow only valid payment statuses" do
    @order.payment_status = "InvalidStatus"
    assert_not @order.valid?
    assert_includes @order.errors[:payment_status], "is not included in the list"
  end

  test "should allow only valid order statuses" do
    @order.status = "UnknownStatus"
    assert_not @order.valid?
    assert_includes @order.errors[:status], "is not included in the list"
  end

  test "should mark order as paid" do
    @order.save!
    @order.mark_as_paid
    assert_equal "Completed", @order.reload.payment_status
  end

  test "should mark order as shipped" do
    @order.save!
    @order.mark_as_shipped
    assert_equal "Shipped", @order.reload.status
  end

  test "should mark order as delivered" do
    @order.save!
    @order.mark_as_delivered
    assert_equal "Delivered", @order.reload.status
  end
end

