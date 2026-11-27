class CategoriesController < ApplicationController
  def show
    @categories = Category.order(:name)
    @category = Category.find(params[:id])
    @products = @category.products.order(:name).page(params[:page]).per(12)
  end
end