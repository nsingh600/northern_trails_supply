class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  belongs_to :province
  has_many :orders, foreign_key: :customer_id, inverse_of: :user, dependent: :destroy
  validates :username, presence: true, uniqueness: { case_sensitive: false }
end
