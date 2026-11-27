require "faker"

OrderItem.destroy_all
Order.destroy_all
Customer.destroy_all
Product.destroy_all
Category.destroy_all
Province.destroy_all

AdminUser.find_or_create_by!(email: "admin@northerntrails.ca") do |admin|
  admin.password = "password"
  admin.password_confirmation = "password"
end

provinces = [
  { name: "Alberta", abbreviation: "AB", gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00 },
  { name: "British Columbia", abbreviation: "BC", gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.00 },
  { name: "Manitoba", abbreviation: "MB", gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.00 },
  { name: "New Brunswick", abbreviation: "NB", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15 },
  { name: "Newfoundland and Labrador", abbreviation: "NL", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15 },
  { name: "Northwest Territories", abbreviation: "NT", gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00 },
  { name: "Nova Scotia", abbreviation: "NS", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15 },
  { name: "Nunavut", abbreviation: "NU", gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00 },
  { name: "Ontario", abbreviation: "ON", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.13 },
  { name: "Prince Edward Island", abbreviation: "PE", gst_rate: 0.00, pst_rate: 0.00, hst_rate: 0.15 },
  { name: "Quebec", abbreviation: "QC", gst_rate: 0.05, pst_rate: 0.09975, hst_rate: 0.00 },
  { name: "Saskatchewan", abbreviation: "SK", gst_rate: 0.05, pst_rate: 0.06, hst_rate: 0.00 },
  { name: "Yukon", abbreviation: "YT", gst_rate: 0.05, pst_rate: 0.00, hst_rate: 0.00 }
]
provinces.each { |p| Province.create!(p) }

categories_data = {
  "Tents & Shelters" => "Four-season alpine tents, backpacking shelters, and heavy-duty tarps built to withstand strong prairie winds and snow loads.",
  "Sleeping Bags & Pads" => "Sub-zero down sleeping bags and insulated sleeping pads rated for cold backcountry nights across northern Canada.",
  "Backpacks & Packs" => "Durable expedition packs, everyday trail daypacks, and weather-resistant dry bags for multi-day treks.",
  "Winter Apparel & Footwear" => "Insulated winter parkas, breathable merino wool base layers, and cold-weather boots designed for ice and snow.",
  "Camp Kitchen & Cookware" => "Reliable camp stoves, lightweight pots and pans, and insulated drinkware for outdoor meal preparation."
}

categories = categories_data.map do |name, desc|
  Category.create!(name: name, description: desc)
end

gear_prefixes = ["Boreal", "Churchill", "Hudson", "Shield", "Tundra", "Whiteshell", "Riding Mountain", "Assiniboine"]

gear_items = {
  "Expedition Tent" => "A weather-resistant shelter with reinforced poles and a full-coverage rainfly for alpine camps and windy clearings.",
  "Down Parka" => "A warm insulated winter jacket with a storm hood and windproof outer shell for sub-zero temperatures.",
  "Trail Pack 65L" => "A spacious multi-day backpack with an adjustable harness, hip belt pockets, and hydration sleeve for long trails.",
  "Insulated Boots" => "Cold-weather hiking and winter boots with thermal lining and high-traction outsoles for snow and packed ice.",
  "Arctic Sleeping Bag" => "A cold-rated sleeping bag with draft collars and lofted insulation to keep you warm in freezing conditions.",
  "Titanium Stove" => "A compact, lightweight camp stove that boils water quickly and packs easily into any backcountry kit.",
  "Merino Base Layer" => "A soft, moisture-wicking thermal top that helps regulate body temperature and resists odor during active outings.",
  "Storm Shell Jacket" => "A waterproof, breathable outer shell jacket that blocks wind, sleet, and rain on exposed ridge trails."
}

item_names = gear_items.keys

105.times do |i|
  cat = categories[i % categories.size]
  prefix = gear_prefixes.sample
  item_name = item_names.sample
  base_desc = gear_items[item_name]

  Product.create!(
    category: cat,
    name: "#{prefix} #{item_name} ##{i + 1}",
    description: "#{base_desc} Offered by Northern Trails Supply Co. in Winnipeg for camping, hiking, and winter travel.",
    price: rand(29.99..599.99).round(2),
    stock_quantity: rand(5..50),
    on_sale: [true, false, false].sample
  )
end

IMAGE_DIR = Rails.root.join("db", "seed_images")

Product.find_each do |product|
  next if product.image.attached?

  slug = product.name.parameterize
  file_path = Dir.glob(IMAGE_DIR.join("#{slug}.{jpg,jpeg,png,webp}")).first
  next unless file_path

  product.image.attach(
    io: File.open(file_path),
    filename: File.basename(file_path),
    content_type: Marcel::MimeType.for(Pathname.new(file_path))
  )
end
[
  {
    slug: "about",
    title: "About Northern Trails Supply Co.",
    body: "Northern Trails Supply Co. equips outdoor explorers with dependable trail and camping gear."
  },
  {
    slug: "contact",
    title: "Contact Us",
    body: "Reach Northern Trails Supply Co. at support@northerntrailssupply.example or visit our storefront."
  }
].each do |attrs|
  page = Page.find_or_initialize_by(slug: attrs[:slug])
  page.update!(attrs)
end
require "faker"

Faker::UniqueGenerator.clear

category_names = [
  "Hiking & Trekking Gear",
  "Camping & Shelters",
  "Trail Apparel & Footwear",
  "Navigation & Hydration"
]

categories = category_names.map do |name|
  Category.find_or_create_by!(name: name) do |cat|
    cat.description = Faker::Lorem.sentence(word_count: 10) if cat.respond_to?(:description=)
  end
end

target_product_count = 104
existing_count = Product.count

if existing_count < target_product_count
  (target_product_count - existing_count).times do |i|
    category = categories[i % categories.length]
    base_price = Faker::Commerce.price(range: 18.0..320.0).round(2)
    on_sale = (i % 4).zero?
    sale_price = on_sale ? (base_price * 0.8).round(2) : nil

    product_attrs = {
      name: "#{Faker::Commerce.unique.product_name} ##{existing_count + i + 1}",
      description: Faker::Lorem.paragraph(sentence_count: 2),
      price: base_price,
      stock_quantity: Faker::Number.between(from: 0, to: 75)
    }

    product_attrs[:category] = category if Product.column_names.include?("category_id")
    if Product.column_names.include?("on_sale")
      product_attrs[:on_sale] = on_sale
      product_attrs[:sale_price] = sale_price if Product.column_names.include?("sale_price")
    end

    product = Product.create!(product_attrs)

    # If using a many-to-many join model (e.g., ProductCategory), associate cleanly:
    if product.respond_to?(:categories) && !product.categories.include?(category)
      product.categories << category
    end
  end
end

puts "Seeded #{Category.count} categories and #{Product.count} products."
require "open-uri"
require "nokogiri"

def seed_from_web_scraper
  base_url = "https://books.toscrape.com/"
  doc = Nokogiri::HTML(URI.open(base_url, "User-Agent" => "Mozilla/5.0"))

  # Grab up to 4 categories from the sidebar
  category_links = doc.css(".side_categories ul li ul li a").first(4)
  scraped_count = 0

  category_links.each do |link|
    cat_name = "Scraped: #{link.text.strip}"
    cat_url = URI.join(base_url, link["href"]).to_s
    category = Category.find_or_create_by!(name: cat_name)

    cat_doc = Nokogiri::HTML(URI.open(cat_url, "User-Agent" => "Mozilla/5.0"))
    cat_doc.css("article.product_pod").first(6).each do |item|
      title = item.css("h3 a").first&.[]("title").to_s.strip
      price_text = item.css(".price_color").first&.text.to_s.gsub(/[^0-9.]/, "")
      price = price_text.empty? ? 29.99 : price_text.to_f

      next if title.empty?

      attrs = {
        description: "Scraped outdoor/reference item: #{title}",
        price: price,
        stock_quantity: 20
      }
      attrs[:category] = category if Product.column_names.include?("category_id")

      product = Product.find_or_create_by!(name: title) do |p|
        p.assign_attributes(attrs)
      end
      product.categories << category if product.respond_to?(:categories) && !product.categories.include?(category)
      scraped_count += 1
    end
  end

  puts "1.7 Web scrape complete (#{scraped_count} items processed)."
rescue StandardError => e
  puts "1.7 Web scrape warning (#{e.class}: #{e.message}) — continuing seed."
end
seed_from_web_scraper
def seed_from_csv_or_api
  puts "1.8 seed hook ran"
end

seed_from_csv_or_api
