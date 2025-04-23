require "test_helper"

class UserTest < ActiveSupport::TestCase

  self.use_transactional_tests = false

  def setup
    @user = User.new(
      name: "Test User",
      email: "test#{SecureRandom.hex(4)}@example.com",  # Ensure unique email
      password: "password123",
      password_confirmation: "password123",
      role: "user"
    )
  end

  test "valid user should be saved" do
    assert @user.valid?, "User is invalid: #{@user.errors.full_messages.join(", ")}"
    assert @user.save, "User was not saved despite being valid"
  end

  test "should not save user without name" do
    user = User.new(email: "valid@example.com", password: "Password123", password_confirmation: "Password123")
    assert_not user.save, "Saved the user without a name"
  end

  test "should not save user without email" do
    user = User.new(name: "Test User", password: "Password123", password_confirmation: "Password123")
    assert_not user.save, "Saved the user without an email"
    assert user.errors[:email].any?, "No validation error for email present"
  end
  
  test "should not save user with duplicate email (case-insensitive)" do
    user1 = User.create!(
      name: "John Doe",
      email: "johndoe@example.com",  # Original email (lowercase)
      password: "Password123",
      password_confirmation: "Password123"
    )
  
    user2 = User.new(
      name: "Jane Doe",
      email: "JOHNDOE@EXAMPLE.COM",  # Case-insensitive duplicate
      password: "Password123",
      password_confirmation: "Password123"
    )
  
    assert_not user2.save, "Saved the user with a duplicate email"
  end
  
  
  test "should not save user with an invalid email format" do
    invalid_emails = %w[user@ user@com user_at_email.com user@domain. user@.com]
    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "Saved user with an invalid email: #{email}"
    end
  end

  test "should not save user without password" do
    user = User.new(name: "Test User", email: "test@example.com")
    assert_not user.save, "Saved the user without a password"
  end

  test "should not save user with short password" do
    user = User.new(
      name: "Test User",
      email: "test@example.com",
      password: "12345",
      password_confirmation: "12345"
    )
    assert_not user.save, "Saved the user with a too short password"
  end

  test "admin? method should return true for admin role" do
    @user.update(role: "admin")
    assert @user.admin?, "admin? did not return true for admin role"
  end

  test "user? method should return true for user role" do
    assert @user.user?, "user? did not return true for user role"
  end
end

