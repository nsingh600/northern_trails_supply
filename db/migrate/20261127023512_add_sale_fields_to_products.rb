class AddSaleFieldsToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :sale_price, :decimal, precision: 10, scale: 2 unless column_exists?(:products, :sale_price)
    add_column :products, :on_sale, :boolean, default: false, null: false unless column_exists?(:products, :on_sale)
  end
end