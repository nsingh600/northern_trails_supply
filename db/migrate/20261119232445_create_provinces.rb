class CreateProvinces < ActiveRecord::Migration[8.1]
  def change
    create_table :provinces do |t|
      t.string :name
      t.string :abbreviation
      t.decimal :gst_rate, precision: 6, scale: 5, default: "0.0", null: false
      t.decimal :pst_rate, precision: 6, scale: 5, default: "0.0", null: false
      t.decimal :hst_rate, precision: 6, scale: 5, default: "0.0", null: false

      t.timestamps
    end
  end
end
