class Category < ApplicationRecord
    has_many :products, dependent: :destroy
    
    validates :name, presence: true, uniqueness: true
    validates :description, presence: true
    has_one_attached :icon # Active Storage for icon

    # Whitelist searchable attributes
  def self.ransackable_attributes(auth_object = nil)
    %w[id name description created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[products]
  end
  
end
  
