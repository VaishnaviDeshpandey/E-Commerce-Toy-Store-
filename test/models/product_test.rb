require "test_helper"
require "rack/test"

class ProductTest < ActiveSupport::TestCase
  include Rack::Test::Methods  # Ensures Rack::Test is included for file uploads

  def setup
    Product.destroy_all   # Ensure no duplicate product names exist
    Category.destroy_all  # Ensure no duplicate categories exist
  
    @category = Category.create!(name: "Electronics", description: "Electronics category")
  
    @product = Product.create!(
      name: "Laptop_#{SecureRandom.hex(4)}",  # Randomized name to avoid duplication
      description: "A high-performance laptop",
      price: 999.99,
      stock_quantity: 10,
      category: @category
    )
  end
  
  test "should be valid with all attributes" do
    assert @product.valid?
  end

  test "should require a name" do
    @product.name = ""
    assert_not @product.valid?
    assert_includes @product.errors[:name], "can't be blank"
  end

  test "should require a description" do
    @product.description = ""
    assert_not @product.valid?
    assert_includes @product.errors[:description], "can't be blank"
  end

  test "should require a price" do
    @product.price = nil
    assert_not @product.valid?
    assert_includes @product.errors[:price], "must be a positive number"
  end

  test "should require a non-negative price" do
    @product.price = -10
    assert_not @product.valid?
    assert_includes @product.errors[:price], "must be a positive number"
  end

  test "should require a stock quantity" do
    @product.stock_quantity = nil
    assert_not @product.valid?
    assert_includes @product.errors[:stock_quantity], "must be a non-negative integer"
  end

  test "should require a non-negative stock quantity" do
    @product.stock_quantity = -5
    assert_not @product.valid?
    assert_includes @product.errors[:stock_quantity], "must be a non-negative integer"
  end

  test "should belong to a category" do
    @product.category = nil
    assert_not @product.valid?
    assert_includes @product.errors[:category], "must exist"
  end

  test "should search products by name and description" do
    @product.save!
    result = Product.search_by_name_and_description("Laptop")
    assert_includes result, @product
  end

  test "should not return unrelated products in search" do
    @product.save!
    other_product = Product.create!(
      name: "Smartphone",
      description: "A powerful smartphone",
      price: 699.99,
      stock_quantity: 5,
      category: @category
    )

    result = Product.search_by_name_and_description("Laptop")
    assert_not_includes result, other_product
  end

  test "should validate image format" do
    invalid_image = Rack::Test::UploadedFile.new(
      Rails.root.join("test/fixtures/files/invalid.txt"), "text/plain"
    )
    @product.images.attach(invalid_image)
    assert_not @product.valid?
    assert_includes @product.errors[:images], "must be a JPEG, PNG, or GIF"
  end

  test "should accept valid image formats" do
    image_path = Rails.root.join("test/fixtures/files/sample.jpg")
    
    assert File.exist?(image_path), "Test image file does not exist: #{image_path}"
    
    valid_image = Rack::Test::UploadedFile.new(image_path, "image/jpeg")
    @product.images.attach(valid_image)
  
    assert @product.valid?
  end
  
end

