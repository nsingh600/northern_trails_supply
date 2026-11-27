class CartItemsController < ApplicationController
  def create
    session[:cart] ||= {}
    pid = params[:product_id].to_s
    qty = [params[:quantity].to_i, 1].max
    return redirect_back(fallback_location: products_path, alert: "Product not found.") unless Product.exists?(pid.to_i)
    session[:cart][pid] = session[:cart][pid].to_i + qty
    redirect_to cart_path, notice: "Added item to cart."
  end
  def update
    session[:cart] ||= {}
    pid = params[:id].to_s
    qty = params[:quantity].to_i
    if qty > 0
      session[:cart][pid] = qty
      redirect_to cart_path, notice: "Updated cart quantity."
    else
      session[:cart].delete(pid)
      redirect_to cart_path, notice: "Removed item from cart."
    end
  end
  def destroy
    session[:cart]&.delete(params[:id].to_s)
    redirect_to cart_path, notice: "Removed item from cart."
  end
end
