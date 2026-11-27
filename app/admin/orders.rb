ActiveAdmin.register Order do
  permit_params :customer_id, :status, :gst_rate, :pst_rate, :hst_rate, :subtotal, :total

  form do |f|
    f.inputs "Order Details" do
      f.input :customer_id
      f.input :status, as: :select, collection: %w[new paid shipped cancelled]
      f.input :gst_rate
      f.input :pst_rate
      f.input :hst_rate
      f.input :subtotal
      f.input :total
    end
    f.actions
  end
end
