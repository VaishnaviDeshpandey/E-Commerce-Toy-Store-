class CreateCartItems < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_items do |t|
      t.integer :product_id, null: false
      t.integer :quantity, null: false, default: 1
      # t.integer :user_id, null: true # Optional, if you want to associate the cart item with a user

      t.timestamps
    end

    # Add foreign key constraints for data integrity
    add_foreign_key :cart_items, :products
    # add_foreign_key :cart_items, :users # If you're tracking users
  end
end
