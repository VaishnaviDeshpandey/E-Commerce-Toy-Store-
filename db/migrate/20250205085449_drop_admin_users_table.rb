class DropAdminUsersTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :admin_users
  end
end
