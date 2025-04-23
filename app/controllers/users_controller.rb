class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]  # ✅ Allow only signup without login


      def index
        @users = User.all  # Adjust this query as needed
      end

      def new
        @user = User.new
      end
    
      # POST /users
      
      def create
        if user_signed_in?  # ✅ Prevent logged-out users from creating users
          @user = User.new(user_params)
          if @user.save
            redirect_to @user, notice: "User was successfully created."
          else
            render :new, status: :unprocessable_entity
          end
        else
          redirect_to new_user_session_path, alert: "You must be logged in to create a user."  # ✅ Prevent unauthorized creation
        end
      end
 
    
      # GET /users/:id
      def show
        @user = User.find_by(id: params[:id])
        if @user
          render json: @user
        else
          redirect_to root_path, alert: "User not found"  # ✅ Redirect instead of returning 404
        end
      end      
           
    
      private
    
      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
      end          
end
