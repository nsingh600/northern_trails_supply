ActiveAdmin.register Product do
  scope :all, default: true
  scope(:on_sale) { |rel| rel.where(on_sale: true) } if Product.column_names.include?("on_sale")
  scope(:new_products) { |rel| rel.where(new_product: true) } if Product.column_names.include?("new_product")
  permit_params :category_id, :name, :description, :price, :stock_quantity, :on_sale, :image

  remove_filter :image_attachment
  remove_filter :image_blob

  filter :category
  filter :name
  filter :price
  filter :stock_quantity
  filter :on_sale
  filter :created_at

  index do
    selectable_column
    id_column
    column :name
    column :category
    column :price
    column :stock_quantity
    column :on_sale
    column :image do |product|
      image_tag url_for(product.image), size: "50x50" if product.image.attached?
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :category
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :on_sale
      f.input :image, as: :file
    end
    f.actions
  end
end