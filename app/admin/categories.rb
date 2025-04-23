ActiveAdmin.register Category do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  permit_params :name, :description, :icon  # Allow image upload

  index do
    selectable_column
    id_column
    column "Icon" do |category|
      if category.icon.attached?
         image_tag url_for(category.icon), size: "40x40"
      else
        "No Icon"
      end
    end
    column :name
    column :description
    column :created_at
    actions
  end

  filter :name

  form do |f|
    f.inputs "Category Details" do
      f.input :icon, as: :file  # Add file upload field
      f.input :name
      f.input :description
    end
    f.actions
  end

  show do
    attributes_table do
      row "Icon" do |category|
        if category.icon.attached?
           image_tag url_for(category.icon), size: "100x100"
        else
          "No Icon"
        end
      end
      row :name
      row :description
      row :created_at
    end
  end
end
