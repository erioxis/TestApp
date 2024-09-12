ActiveAdmin.register CargoRequest do
  permit_params :first_name, :last_name, :middle_name, :phone, :email, :weight, :length, :width, :height, :origin, :destination, :distance, :price

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :middle_name
    column :phone
    column :email
    column :weight
    column :length
    column :width
    column :height
    column :origin
    column :destination
    column :distance
    column :price
    actions
  end

  form do |f|
    f.inputs 'Cargo Request Details' do
      f.input :first_name
      f.input :last_name
      f.input :middle_name
      f.input :phone
      f.input :email
      f.input :weight
      f.input :length
      f.input :width
      f.input :height
      f.input :origin
      f.input :destination
      f.input :distance
      f.input :price
    end
    f.actions
  end
end
