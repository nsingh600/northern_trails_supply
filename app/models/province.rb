class Province < ApplicationRecord
  has_many :customers, dependent: :nullify

  validates :name, :abbreviation, presence: true, uniqueness: true
  validates :gst_rate, :pst_rate, :hst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
