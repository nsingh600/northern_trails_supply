class Product < ApplicationRecord
  belongs_to :category
  has_one_attached :image

  validate :acceptable_image

  private

  def acceptable_image
    return unless image.attached?

    unless image.byte_size <= 5.megabytes
      errors.add(:image, "must be under 5 MB")
    end

    acceptable_types = %w[image/jpeg image/png image/webp]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be a JPEG, PNG, or WebP")
    end
  end
end
class Product < ApplicationRecord
  # Keep your existing associations and validations

  scope :on_sale_products, -> { where(on_sale: true) }
  scope :new_products, -> { where("created_at >= ?", 3.days.ago) }
  scope :recently_updated_products, lambda {
    where("updated_at >= ? AND created_at < ?", 3.days.ago, 3.days.ago)
  }

  def self.ransackable_scopes(_auth_object = nil)
    %w[on_sale_products new_products recently_updated_products]
  end
end