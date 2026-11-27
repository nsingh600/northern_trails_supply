require "fileutils"
require "open-uri"

tmp_dir = Rails.root.join("tmp", "sample_gear_images")
FileUtils.mkdir_p(tmp_dir)

category_colors = {
  "Tents & Shelters" => ["#1b4332", "TENT / SHELTER"],
  "Sleeping Bags & Pads" => ["#2d6a4f", "SLEEPING GEAR"],
  "Backpacks & Packs" => ["#40916c", "TRAIL PACK"],
  "Winter Apparel & Footwear" => ["#1d3557", "WINTER GEAR"],
  "Camp Kitchen & Cookware" => ["#bc6c25", "CAMP KITCHEN"]
}

# Create simple 1x1 PNG fallback bytes if ImageMagick is not installed
png_1x1 = Base64.decode64(
  "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg=="
)

category_files = {}

Category.find_each do |category|
  bg, label = category_colors.fetch(category.name, ["#2d6a4f", category.name.upcase])
  file_path = tmp_dir.join("#{category.name.parameterize}.png")

  if system("which magick >/dev/null 2>&1")
    system(
      "magick", "-size", "600x400", "xc:#{bg}",
      "-gravity", "center", "-fill", "white", "-pointsize", "36",
      "-annotate", "+0+0", label, file_path.to_s
    )
  elsif system("which convert >/dev/null 2>&1")
    system(
      "convert", "-size", "600x400", "xc:#{bg}",
      "-gravity", "center", "-fill", "white", "-pointsize", "36",
      "-annotate", "+0+0", label, file_path.to_s
    )
  else
    File.binwrite(file_path, png_1x1)
  end

  category_files[category.id] = file_path
end

Product.includes(:category).find_each do |product|
  next if product.image.attached?

  source_file = category_files[product.category_id]
  next unless source_file && File.exist?(source_file)

  product.image.attach(
    io: File.open(source_file),
    filename: "#{product.name.parameterize}.png",
    content_type: "image/png"
  )
end

puts "Attached images to #{Product.joins(:image_attachment).count} products."