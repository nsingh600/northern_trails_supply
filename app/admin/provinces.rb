ActiveAdmin.register Province do
  permit_params :name, :abbreviation, :code, :gst_rate, :pst_rate, :hst_rate
  remove_filter :users, :orders
end
