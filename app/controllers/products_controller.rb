class ProductsController < ApplicationController
  def index
    products = Product.all

    case params[:filter]
    when "on_sale"
      products = products.on_sale_products
    when "new"
      products = products.new_products
    when "recently_updated"
      products = products.recently_updated_products
    end

    @filter = params[:filter]
    @products = products.order(created_at: :desc).page(params[:page]).per(9)
  end

  def show
    @product = Product.find(params[:id])
  end
end