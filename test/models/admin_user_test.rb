require "test_helper"

class AdminUserTest < ActiveSupport::TestCase
  def setup
    @admin = AdminUser.new(email: "admin#{rand(1000)}@example.com", password: "password123", password_confirmation: "password123")
  end  

  test "should be valid with all attributes" do
    admin = AdminUser.new(email: "valid@example.com", password: "securepass123")
    assert admin.valid?, "AdminUser should be valid with email and password"
  end  

  test "should require an email" do
    @admin.email = ""
    assert_not @admin.valid?, "AdminUser should not be valid without an email"
  end

  test "should require a password" do
    @admin.password = ""
    assert_not @admin.valid?, "AdminUser should not be valid without a password"
  end

  test "should not allow duplicate emails" do
    @admin.save
    duplicate_admin = @admin.dup
    assert_not duplicate_admin.valid?, "AdminUser should not allow duplicate emails"
  end

  test "should require a properly formatted email" do
    invalid_emails = ["admin", "admin@", "admin.com"] # Remove "admin@com"
    invalid_emails.each do |invalid_email|
      @admin.email = invalid_email
      assert_not @admin.valid?, "#{invalid_email.inspect} should be invalid"
    end
  end  

  test "should allow valid email format" do
    admin = AdminUser.new(email: "unique_admin#{rand(1000)}@example.com", password: "password123")
    assert admin.valid?, "#{admin.errors.full_messages.join(', ')}"
  end  
    
end

