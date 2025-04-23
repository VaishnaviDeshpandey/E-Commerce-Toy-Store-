class AddPaymentStatusToOrders < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:orders, :status)
      add_column :orders, :status, :string, default: "Processing"
    end

    unless column_exists?(:orders, :payment_status)
      add_column :orders, :payment_status, :string, default: "Pending"
    end
  end
end
