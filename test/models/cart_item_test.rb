require "test_helper"

class CartItemTest < ActiveSupport::TestCase
  def setup
    @product = Product.create(name: "Toy Car", price: 10.99, description: "A small toy car") 
    @cart_item = CartItem.new(product: @product, quantity: 2)
  end

  test "should be valid with all attributes" do
    assert @cart_item.valid?
  end

  test "should require a product" do
    @cart_item.product = nil
    assert_not @cart_item.valid?, "CartItem should not be valid without a product"
  end

  test "should require quantity to be at least 1" do
    @cart_item.quantity = 0
    assert_not @cart_item.valid?, "CartItem should not allow quantity less than 1"
  end

  test "should calculate total price correctly" do
    assert_equal 21.98, @cart_item.total_price, "Total price should be product price * quantity"
  end
end

