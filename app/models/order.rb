class Order < ApplicationRecord
    belongs_to :user
    has_many :order_items, dependent: :destroy

    validates :customer_name, presence: true
    validates :shipping_address, presence: true
    validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
    validates :payment_method, presence: true
    validates :payment_status, inclusion: { in: ["Pending", "Completed"] }
    validates :status, inclusion: { in: ["Pending", "Shipped", "Delivered", "Cancelled"] }

  def mark_as_paid
    update(payment_status: "Completed")
  end

  def mark_as_shipped
    update(status: "Shipped")
  end

  def mark_as_delivered
    update(status: "Delivered")
  end

  def self.ransackable_attributes(auth_object = nil)
    # You can include more attributes here as needed
    ["id", "customer_name", "total_price", "status", "created_at", "updated_at", "user_id"]
  end

  # Explicitly allow associations to be searched
  def self.ransackable_associations(auth_object = nil)
    ["user", "order_items"]  # Add "order_items" here to allow filtering on the association
  end
end
  
