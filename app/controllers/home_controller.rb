class HomeController < ApplicationController
  def index
    @products = Product.limit(5)  # Fetch first 5 products (you can change this as needed)
  end
end
