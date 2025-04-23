ActiveAdmin.register Product do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description, :price, :stock_quantity, :category_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :price, :stock_quantity, :category_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  permit_params :name, :description, :price, :stock_quantity, :category_id, images: []  # ✅ Added :stock_quantity

  # controller do
  #   before_action :authorize_admin

  #   def authorize_admin
  #     redirect_to root_path unless current_user&.admin?
  #   end
    
  # end
  
    index do
      selectable_column
      id_column
      column "Images" do |product|
        product.images.map do |image|
          image_tag url_for(image), size: "50x50"
        end.join(" ").html_safe
      end
      column :name
      column :category
      column :price
      column :stock_quantity
      column :created_at
      actions
    end
  
    filter :name
    filter :category
    filter :price
    filter :stock_quantity
  
    form do |f|
      f.inputs "Product Details" do
        f.input :images, as: :file, input_html: { multiple: true }
        f.input :name
        f.input :description
        f.input :price
        f.input :stock_quantity  # ✅ Added stock_quantity field
        f.input :category
      end
      f.actions
    end

    show do
      attributes_table do
        row "Images" do |product|
          product.images.map do |image|
            image_tag url_for(image), size: "200x200"
          end.join(" ").html_safe
        end
        row :name
        row :description
        row :price
        row :stock_quantity
        row :category
      end
    end
  
end
