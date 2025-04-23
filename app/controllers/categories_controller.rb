class CategoriesController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]  # ✅ Restrict actions to logged-in users
    before_action :authorize_admin, only: [:new, :create, :edit, :update, :destroy]  
    before_action :set_category, only: [:show, :edit, :update, :destroy]
  
    def index
      if params[:query].present?
        @categories = Category.where("name ILIKE ?", "%#{params[:query]}%")
      else
        @categories = Category.all
      end
    end
    
  
    def show
    end
  
    def new
      @category = Category.new
    end
  
    def create
      authorize_admin  # ✅ Restrict access
    
      @category = Category.new(category_params)
      if @category.save
        redirect_to @category, notice: "Category was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end
    
  
    def edit
    end
  
    def update
      authorize_admin  
      if @category.update(category_params)  
        redirect_to @category, notice: "Category was successfully updated."
      else
        flash.now[:alert] = @category.errors.full_messages.join(", ")
        render :edit, status: :unprocessable_entity
      end
    end    
        
    def destroy
      authorize_admin  # ✅ Restrict deletes to admins
      @category.destroy
      redirect_to categories_url, notice: "Category was successfully destroyed."
    end    
  
    private
  
    def set_category
      @category = Category.find(params[:id])
    end
  
    def category_params
      params.require(:category).permit(:name, :description, :icon)
    end

    def authorize_admin
      if !user_signed_in?
        redirect_to new_user_session_path, alert: "You must sign in first."
      elsif !current_user.admin?
        redirect_to root_path, alert: "Access denied!"
      end
    end    
    
end
  
