class CreateProvinces < ActiveRecord::Migration[7.1]
  def change
    create_table :provinces do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.decimal :gst_rate, precision: 6, scale: 5, default: 0.0
      t.decimal :pst_rate, precision: 6, scale: 5, default: 0.0
      t.decimal :hst_rate, precision: 6, scale: 5, default: 0.0

      t.timestamps
    end
    add_index :provinces, :code, unique: true
  end
end
