module ProductsHelper
  CARD_PICTURES = [
    "https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?auto=format&fit=crop&w=800&q=80", # Tent / camping
    "https://images.unsplash.com/photo-1551632811-561732d1e306?auto=format&fit=crop&w=800&q=80", # Hiking trail / gear
    "https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?auto=format&fit=crop&w=800&q=80", # Campfire / outdoor gear
    "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=80", # Mountain / alpine expedition
    "https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?auto=format&fit=crop&w=800&q=80", # Backpack / trail pack
    "https://images.unsplash.com/photo-1510312305653-8ed496efae75?auto=format&fit=crop&w=800&q=80"  # Outdoor camping setup
  ].freeze

  def product_card_image_url(product, index = 0)
    if product.respond_to?(:image) && product.image.attached?
      url_for(product.image)
    else
      key = product.id.present? ? product.id : index
      CARD_PICTURES[key.to_i % CARD_PICTURES.length]
    end
  end
end