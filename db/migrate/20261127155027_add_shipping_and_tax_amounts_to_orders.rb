class AddShippingAndTaxAmountsToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :street_address, :string
    add_column :orders, :city, :string
    add_column :orders, :postal_code, :string
    add_column :orders, :gst_amount, :decimal
    add_column :orders, :pst_amount, :decimal
    add_column :orders, :hst_amount, :decimal
  end
end
