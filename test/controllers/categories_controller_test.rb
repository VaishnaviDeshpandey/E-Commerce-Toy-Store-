require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers  # Enables Devise helpers

  def setup
    @category = Category.find_or_create_by!(name: "Electronics") do |c|
      c.description = "Devices and gadgets"
    end
  
    @admin = User.find_or_create_by!(email: "admin@example.com") do |user|
      user.name = "Admin"
      user.password = "password123"
      user.role = "admin"
      user.admin = true  # Ensure admin flag is set
    end
  
    @user = User.find_or_create_by!(email: "user@example.com") do |user|
      user.name = "User"
      user.password = "password123"
      user.role = "user"
      user.admin = false
    end
  
    # ✅ Explicitly specify the Devise scope
    sign_in @user, scope: :user
  end
  
  

  ## ✅ Test Index Action
  test "should get index" do
    get categories_path
    assert_response :success
    assert_select "h1", "Categories"
  end

  ## ✅ Test Show Action
  test "should show category" do
    get category_path(@category)
    assert_response :success
    assert_select "h1", @category.name
  end

  ## ✅ Test New Action (Access Restriction)
  test "should redirect new when not logged in" do
    sign_out @user  # Ensure user is signed out
    get new_category_path
    assert_redirected_to new_user_session_path  # ✅ Correct redirect for unauthenticated users
  end
  
  ## ✅ Test Create Action
  test "should create category as admin" do
    sign_in @admin
    assert_difference("Category.count", 1) do
      post categories_path, params: { category: { name: "Books#{SecureRandom.hex(2)}", description: "All kinds of books" } }
    end
    assert_redirected_to category_path(Category.last)
  end
  

  ## ✅ Test Preventing Non-Admin from Creating Category
  test "should not allow non-admin to create category" do
    sign_in @user, scope: :user
    assert_no_difference("Category.count") do
      post categories_path, params: { category: { name: "Unauthorized", description: "Not allowed" } }
    end
    assert_redirected_to root_path  # ✅ Ensure non-admin is blocked
    assert_equal "Access denied!", flash[:alert]
  end  
  
  ## ✅ Test Edit Action (Access Restriction)
  test "should redirect edit when not logged in" do
    sign_out @user  # Ensure user is signed out
    get edit_category_path(@category)
    assert_redirected_to new_user_session_path  # ✅ Correct redirect for unauthenticated users
  end
  
  
  ## ✅ Test Update Action
  test "should update category as admin" do
    sign_in @admin, scope: :user  # ✅ Explicitly define Devise scope
    patch category_path(@category), params: { category: { 
      name: "Updated Electronics",
      description: "Updated Description"
    } }
    assert_redirected_to category_path(@category)
    @category.reload
    assert_equal "Updated Electronics", @category.name
  end
  
   

  ## ✅ Test Preventing Non-Admin from Updating Category
  test "should not allow non-admin to update category" do
    sign_in @user
    patch category_path(@category), params: { category: { name: "Hacking Tools" } }
    assert_redirected_to root_path  # ✅ Ensure non-admin is blocked
    assert_equal "Access denied!", flash[:alert]
  end  

  ## ✅ Test Destroy Action (Admin Only)
  test "should delete category as admin" do
    sign_in @admin
    assert_difference("Category.count", -1) do
      delete category_path(@category)
    end
    assert_redirected_to categories_path
    assert_equal "Category was successfully destroyed.", flash[:notice]
  end

  ## ✅ Test Preventing Non-Admin from Deleting Category
  
  test "should not allow non-admin to delete category" do
    sign_in @user, scope: :user
    assert_no_difference("Category.count") do
      delete category_path(@category)
    end
    assert_redirected_to root_path  # ✅ Ensure non-admin is blocked
    assert_equal "Access denied!", flash[:alert]
  end  

end

