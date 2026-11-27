class CartsController < ApplicationController
  def show
    cart = session[:cart] || {}
    @cart_items = cart.filter_map do |pid, qty|
      product = Product.find_by(id: pid.to_i)
      q = qty.to_i
      next if product.nil? || q <= 0
      { product: product, quantity: q, line_total: product.price.to_f * q }
    end
    @subtotal = @cart_items.sum { |row| row[:line_total] }
  end

  def add
    session[:cart] ||= {}
    pid = params[:product_id].to_s
    qty = [params[:quantity].to_i, 1].max
    return redirect_back(fallback_location: products_path, alert: "Product not found.") unless Product.exists?(pid.to_i)
    session[:cart][pid] = session[:cart][pid].to_i + qty
    redirect_to cart_path, notice: "Added item to cart."
  end
end
