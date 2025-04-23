# app/models/product.rb
class Product < ApplicationRecord
    belongs_to :category
    has_many :cart_items
    has_many_attached :images
    has_many :order_items, dependent: :destroy  # Ensure order_items are deleted when product is deleted

    validate :correct_image_type

  def correct_image_type
    images.each do |image|
      unless image.content_type.in?(%('image/jpeg image/png image/gif'))
        errors.add(:images, 'must be a JPEG, PNG, or GIF')
      end
    end
  end

    include PgSearch::Model

  pg_search_scope :search_by_name_and_description, 
                  against: [:name, :description], 
                  using: {
                    tsearch: { prefix: true } # Enables partial matching
                  }
    
    validates :name, presence: true
    validates :description, presence: true
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0, message: "must be a positive number" }
    validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "must be a non-negative integer" }
    validates :category_id, presence: true

  # Whitelist searchable attributes
  def self.ransackable_attributes(auth_object = nil)
    %w[id name price stock_quantity category_id created_at updated_at]  # ✅ Added stock_quantity
  end    

  # Optional: Specify ransackable associations if needed
  def self.ransackable_associations(auth_object = nil)
    %w[category]
  end
end
  
