ActiveAdmin.register Order do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :user_id, :shipping_address, :total_price, :status, :payment_status, :payment_method
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :shipping_address, :total_price, :status, :payment_status, :payment_method]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # Permitting parameters for admin updates

  permit_params :status, :customer_name, :shipping_address, :total_price, :payment_status, :payment_method

  # Display columns in the index view
  index do
    selectable_column
    id_column
    column :customer_name
    column :status
    column :total_price
    column :created_at
    actions
  end

  # Filters to search and sort orders
  filter :customer_name
  filter :status
  filter :created_at

  # Form for editing orders
  form do |f|
    f.inputs 'Order Details' do
      f.input :customer_name
      f.input :status, as: :select, collection: ["Pending", "Shipped", "Delivered", "Cancelled"]
      f.input :payment_status, as: :select, collection: ["Pending", "Completed"]
      f.input :payment_method
      f.input :shipping_address
      f.input :total_price
    end
    f.actions
  end

  # Show page customization
  show do
    attributes_table do
      row :id
      row :customer_name
      row :status
      row :shipping_address
      row :total_price
      row :created_at
    end
  end
  
end
