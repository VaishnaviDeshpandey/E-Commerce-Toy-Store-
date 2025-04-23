require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  setup do
    @category = Category.create(name: "Electronics")
    @product = Product.create(
      name: "Laptop",
      description: "A high-performance laptop",
      price: 999.99,
      stock_quantity: 10,
      category: @category
    )
    @admin_user = User.create(email: "admin@example.com", password: "password", admin: true)
  end

  test "visiting the products index" do
    visit products_url
    assert_selector "h1", text: "Products"
  end

  test "searching for a product" do
    visit products_url
    fill_in "query", with: "Laptop"
    click_on "Search"
    assert_text "Laptop"
  end

  test "creating a new product as admin" do
    sign_in_as(@admin_user)
    visit new_product_url
    fill_in "Name", with: "Tablet"
    fill_in "Description", with: "A powerful tablet"
    fill_in "Price", with: 599.99
    fill_in "Stock quantity", with: 5
    select "Electronics", from: "Category"
    click_on "Create Product"
    assert_text "Product was successfully created"
  end

  test "updating a product as admin" do
    sign_in_as(@admin_user)
    visit edit_product_url(@product)
    fill_in "Name", with: "Updated Laptop"
    click_on "Update Product"
    assert_text "Product was successfully updated"
  end

  test "deleting a product as admin" do
    sign_in_as(@admin_user)
    visit products_url
    accept_confirm do
      click_on "Destroy", match: :first
    end
    assert_text "Product was successfully destroyed"
  end

  private

  def sign_in_as(user)
    visit login_url
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_on "Log in"
  end
end
