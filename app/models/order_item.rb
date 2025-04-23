class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  # Example of filtering by a product_id in an order_item
  scope :filter_by_product, ->(product_id) { where(product_id: product_id) }
end
