require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  def setup
    OrderItem.destroy_all  # Remove order_items first to avoid foreign key violations
    Product.destroy_all    # Then remove products
    Category.destroy_all   # Finally, clear categories to avoid duplicate names
  
    @category = Category.new(
      name: "Electronics",
      description: "Gadgets and devices"
    )
  end

  test "should be valid with all attributes" do
    assert @category.valid?
  end

  test "should require a name" do
    @category.name = ""
    assert_not @category.valid?
    assert_includes @category.errors[:name], "can't be blank"
  end

  test "should require a description" do
    @category.description = ""
    assert_not @category.valid?
    assert_includes @category.errors[:description], "can't be blank"
  end

  test "should require a unique name" do
    @category.save!
    duplicate_category = Category.new(name: "Electronics", description: "Duplicate category")
    assert_not duplicate_category.valid?
    assert_includes duplicate_category.errors[:name], "has already been taken"
  end

  test "should destroy associated products" do
    @category.save!
    product = @category.products.create!(
      name: "Laptop",
      description: "Gaming Laptop",
      price: 1200.99,
      stock_quantity: 5
    )
    
    assert_difference "Product.count", -1 do
      @category.destroy
    end
  end

  test "should allow attaching an icon" do
    @category.icon.attach(
      io: File.open(Rails.root.join("test/fixtures/files/sample.jpg")),
      filename: "sample.jpg",
      content_type: "image/jpeg"
    )
    
    assert @category.icon.attached?
  end
end

