require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    Rails.cache.clear  # Clears any cached test data
  
    User.destroy_all   # Ensure no duplicates exist
  
    @user = User.create!(
      name: "Test User",
      email: "test_#{SecureRandom.hex(4)}@example.com", # Unique email
      password: "password",
      password_confirmation: "password",
      role: "user"
    )
  
    @admin = User.create!(
      name: "Admin User",
      email: "admin_#{SecureRandom.hex(4)}@example.com", # Unique email
      password: "password",
      password_confirmation: "password",
      role: "admin"
    )
  end
   

  # ✅ Test: Get Index (Only for logged-in users)
  test "should get index if logged in" do
    sign_in_as(@admin)
    get users_path
    assert_response :success
  end  

  test "should redirect index if not logged in" do
    get users_path
    assert_redirected_to new_user_session_path
  end

  # ✅ Test: New User (Signup Page)
  test "should get new" do
    get new_user_path
    assert_response :success
  end

  # ✅ Test: Create User (Signup)
  test "should create user" do
    assert_difference "User.count", 1 do
      post users_path, params: { user: { name: "New User", email: "new@example.com", password: "password", password_confirmation: "password" } }
    end
    follow_redirect!
    assert_response :success  # Ensure the user is redirected correctly
  end
    
  test "should prevent duplicate user creation" do
    assert_no_difference "User.count" do
      post users_path, params: { user: { name: "Test User", email: @user.email, password: "password", password_confirmation: "password" } }
    end
    assert_response :unprocessable_entity
  end

  # ✅ Test: Show User
  test "should show user" do
    sign_in_as(@user)
    get user_path(@user.id), as: :json  # Explicitly request JSON format
    
    puts "Response body: #{@response.body}"  # Debugging output
  
    assert_response :success
    assert_match @user.email, @response.body  # Ensure JSON contains user data
  end  
              
  
  test "should redirect show when user not found" do
    sign_in_as(@user)  # Ensure user is logged in
    get user_path(-1)
    assert_redirected_to root_path
  end  

  private

  # 🔹 Sign in Helper (since Devise's sign_in helper is not available in integration tests)
  def sign_in_as(user)
    post user_session_path, params: { user: { email: user.email, password: "password" } }
    follow_redirect!  # Ensure redirect after login
  end  
end
