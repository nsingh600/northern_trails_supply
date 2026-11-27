class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :status
     t.decimal :gst_rate, precision: 6, scale: 5, default: "0.0", null: false
t.decimal :pst_rate, precision: 6, scale: 5, default: "0.0", null: false
t.decimal :hst_rate, precision: 6, scale: 5, default: "0.0", null: false
t.decimal :subtotal, precision: 10, scale: 2, null: false
t.decimal :total, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
