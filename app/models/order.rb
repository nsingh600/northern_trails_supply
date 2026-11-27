class Order < ApplicationRecord
  belongs_to :user, foreign_key: :customer_id, inverse_of: :orders
  belongs_to :province
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  validates :status, :subtotal, :total, presence: true
end
