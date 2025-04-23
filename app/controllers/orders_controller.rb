class OrdersController < ApplicationController

  include Pundit::Authorization  # ✅ FIXED

  before_action :authenticate_user!
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  def index
    # @orders = current_user.orders.order(created_at: :desc)
    @orders = policy_scope(Order).order(created_at: :desc)
    authorize Order
  end

  def admin_index
    # @orders = Order.order(created_at: :desc)
    authorize Order, :admin_index?
    @orders = Order.order(created_at: :desc)
  end

  def new
    @order = Order.new
    authorize @order
  end

  def create
    cart = current_cart
    return redirect_to cart_path, alert: "Your cart is empty!" if cart.empty?
  
    @order = current_user.orders.build(order_params.merge(
    customer_name: current_user.name.presence,
    total_price: calculate_total(cart),
    status: "Pending",  # FIXED ✅
    payment_status: "Pending"
    ))
  
    authorize @order
  
    if @order.save
      cart.each do |product_id, quantity|
        product = Product.find(product_id)
        @order.order_items.create!(product: product, quantity: quantity, price: product.price)
      end
      session[:cart] = {}
      redirect_to thank_you_order_path(@order), notice: "Order placed successfully!"
    else
      flash.now[:alert] = @order.errors.full_messages.join(", ")
      render :new
    end
  end
  
  
  def confirm_payment
    @order = Order.find(params[:id])
    authorize @order, :confirm_payment?
    @order.mark_as_paid
    redirect_to @order, notice: "Payment marked as completed!"
  end

  def show
    @order = Order.find(params[:id])
    authorize @order
  end

  def update
    @order = Order.find(params[:id])
    authorize @order

    if @order.update(order_params)
      redirect_to admin_orders_path, notice: "Order updated successfully!"
    else
      render :admin_index
    end
  end

  def destroy
    @order = Order.find(params[:id])
    authorize @order
    @order.destroy
    redirect_to admin_orders_path, notice: "Order deleted successfully!"
  end

  def thank_you
    @order = Order.find(params[:id])
    authorize @order  # 🔥 This line ensures Pundit authorization
  end  

  private

  def order_params
    params.require(:order).permit(:shipping_address, :payment_method, :status, :payment_status, :customer_name)
  end

  def calculate_total(cart)
    cart.sum { |product_id, quantity| Product.find(product_id).price * quantity }
  end

  # def authenticate_admin!
  #   redirect_to root_path, alert: "Access denied!" unless current_user.admin?
  # end
end

