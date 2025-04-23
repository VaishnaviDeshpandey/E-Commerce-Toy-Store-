require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  def setup
    Product.destroy_all
    Category.destroy_all
    User.destroy_all
  
    @category = Category.create!(name: "Electronics", description: "Electronic gadgets")
  
    @product = Product.create!(
      name: "Laptop",
      description: "High-performance laptop",
      price: 50000,
      stock_quantity: 10,
      category: @category
    )
  
    @admin = User.create!(
      name: "Admin User",
      email: "admin@example.com",
      password: "Welcome12",
      password_confirmation: "Welcome12",
      role: "admin"
    )
    
    @user = User.create!(
      name: "Regular User",
      email: "user@example.com",
      password: "Welcome12",
      password_confirmation: "Welcome12",
      role: "user"
    )
  end
  

  ### ✅ PUBLIC ACTIONS (NO LOGIN REQUIRED)

  test "should get index" do
    get products_url
    assert_response :success
    assert_select "h1", "Products"
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  
    puts response.body  # 🔍 Print HTML response for debugging
  
    assert_select "h5", @product.name  # ✅ Ensure correct element is checked
  end
  

  ### 🚨 PROTECTED ACTIONS (ONLY ADMIN)

  test "should redirect new when not logged in" do
    get new_product_url
    assert_redirected_to root_url
    assert_equal "Access denied!", flash[:alert]
  end

  test "should allow admin to access new product page" do
    sign_in_as(@admin)
    get new_product_url
    assert_response :success
  end

  test "should prevent normal user from accessing new product page" do
    sign_in_as(@user)
    get new_product_url
    assert_redirected_to root_url
    assert_equal "Access denied!", flash[:alert]
  end

  ### 🚀 CREATE PRODUCT

  test "should create product as admin" do
    sign_in_as(@admin)
    assert_difference "Product.count", 1 do
      post products_url, params: {
        product: {
          name: "Phone",
          description: "Smartphone",
          price: 20000,
          stock_quantity: 5,
          category_id: @category.id
        }
      }
    end
    assert_redirected_to product_url(Product.last)
    assert_equal "Product was successfully created.", flash[:notice]
  end

  test "should not create product with invalid data" do
    sign_in_as(@admin)
    assert_no_difference "Product.count" do
      post products_url, params: {
        product: {
          name: "",
          description: "Smartphone",
          price: -5,  # Invalid price
          stock_quantity: -3, # Invalid quantity
          category_id: @category.id
        }
      }
    end
    assert_response :unprocessable_entity
  end

  ### 📝 UPDATE PRODUCT

  test "should update product as admin" do
    sign_in_as(@admin)
    patch product_url(@product), params: {
      product: { name: "Updated Laptop" }
    }
    assert_redirected_to product_url(@product)
    @product.reload
    assert_equal "Updated Laptop", @product.name
  end

  test "should prevent non-admin from updating product" do
    sign_in_as(@user)
    patch product_url(@product), params: { product: { name: "New Name" } }
    assert_redirected_to root_url
    @product.reload
    assert_not_equal "New Name", @product.name
  end

  ### ❌ DELETE PRODUCT

  test "should delete product as admin" do
    sign_in_as(@admin)
    assert_difference "Product.count", -1 do
      delete product_url(@product)
    end
    assert_redirected_to products_url
    assert_equal "Product was successfully destroyed.", flash[:notice]
  end

  test "should prevent non-admin from deleting product" do
    sign_in_as(@user)
    assert_no_difference "Product.count" do
      delete product_url(@product)
    end
    assert_redirected_to root_url
  end

  ### 🔍 SEARCH & FILTER

  test "should return search results" do
    get products_url, params: { query: "Laptop" }
    assert_response :success
    assert_select "h1", "Products"
  end

  test "should filter products by category" do
    get products_url, params: { category_id: @category.id }
    assert_response :success
    assert_select "h1", "Products"
  end

  ### 🛠 HELPER METHOD FOR LOGIN

  private

  def sign_in_as(user)
    sign_in user  # ✅ Use Devise helper
  end
end
