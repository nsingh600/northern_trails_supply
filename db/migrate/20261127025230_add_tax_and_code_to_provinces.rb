class AddTaxAndCodeToProvinces < ActiveRecord::Migration[7.1]
  def change
    add_column :provinces, :code, :string unless column_exists?(:provinces, :code)
    add_column :provinces, :gst_rate, :decimal, precision: 6, scale: 5, default: 0.0 unless column_exists?(:provinces, :gst_rate)
    add_column :provinces, :pst_rate, :decimal, precision: 6, scale: 5, default: 0.0 unless column_exists?(:provinces, :pst_rate)
    add_column :provinces, :hst_rate, :decimal, precision: 6, scale: 5, default: 0.0 unless column_exists?(:provinces, :hst_rate)
    add_index :provinces, :code, unique: true unless index_exists?(:provinces, :code)
  end
end
