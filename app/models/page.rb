class Page < ApplicationRecord
  validates :title, :slug, :body, presence: true
  validates :slug, uniqueness: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[id title slug body created_at updated_at]
  end
end