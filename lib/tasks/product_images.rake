namespace :products do
  desc "Attach images from db/seed_images matching product names"
  task attach_images: :environment do
    image_dir = Rails.root.join("db", "seed_images")
    overwrite = ENV["OVERWRITE"] == "true"

    Product.find_each do |product|
      next if product.image.attached? && !overwrite

      slug = product.name.parameterize
      file_path = Dir.glob(image_dir.join("#{slug}.{jpg,jpeg,png,webp}")).first
      next unless file_path

      product.image.attach(
        io: File.open(file_path),
        filename: File.basename(file_path),
        content_type: Marcel::MimeType.for(Pathname.new(file_path))
      )
      puts "Attached #{File.basename(file_path)} to #{product.name}"
    end
  end
end