# app/controllers/products_controller.rb
class ProductsController < ApplicationController
    # before_action :authenticate_user!  # Ensure users are logged in
    # skip_before_action :authenticate_user!, only: [:index, :show]
    before_action :authorize_admin, only: [:new, :create, :edit, :update, :destroy]  # Restrict actions
    before_action :set_product, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, except: [:new, :create, :index, :show]  # ✅ Allow only new users to sign up

  
    # GET /products
    def index
      @categories = Category.all # Fetch all categories for filtering dropdown
  
      @products = Product.order(created_at: :desc)
  
      # Search functionality
      if params[:query].present?
        @products = @products.search_by_name_and_description(params[:query])
      end
  
      # Category filter
      if params[:category_id].present?
        @products = @products.where(category_id: params[:category_id])
      end
  
      @products = @products.page(params[:page]).per(1) # Paginate results
    end  
  
    # GET /products/1
    def show
    end
  
    # GET /products/new
    def new
      @product = Product.new
    end
  
    # POST /products
    def create
      @product = Product.new(product_params)  # ✅ Correct method
      if @product.save
        redirect_to @product, notice: "Product was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end      
  
    # GET /products/1/edit
    def edit
    end
  
    # PATCH/PUT /products/1
    def update
      if @product.update(product_params)
        redirect_to @product, notice: 'Product was successfully updated.'
      else
        render :edit
      end
    end
  
    # DELETE /products/1
    def destroy
      @product = Product.find(params[:id])
      if @product.destroy
        redirect_to products_url, notice: 'Product was successfully destroyed.'
      else
        redirect_to products_url, alert: 'Failed to delete product.'
      end
    end    
  
    private
      # Set product for actions like show, edit, update, destroy
      def set_product
        @product = Product.find(params[:id])
      end      
  
      # Only allow a list of trusted parameters through
      def product_params
        params.require(:product).permit(:name, :description, :price, :stock_quantity, :category_id, images: [])
      end


      def authorize_admin
        unless current_user&.admin?  # ✅ Safe check using &.
          redirect_to root_path, alert: "Access denied!"
        end
      end      
  end
  