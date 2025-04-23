class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :orders, dependent: :destroy
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
    validates :name, presence: true
    validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "must be a valid email address" }
    validates :role, inclusion: { in: %w[user admin], message: "%{value} is not a valid role" }

    def self.ransackable_attributes(auth_object = nil)
      ["id", "email", "name", "created_at", "updated_at"] # Add other safe attributes if needed
    end

    # before_save :set_default_role

    # private

    # def set_default_role
    #   self.role ||= 'user'
    # end

    # Define role-checking methods
  def admin?
    role == 'admin'
  end

  def user?
    role == 'user'
  end
end
