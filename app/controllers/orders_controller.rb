require "bigdecimal"
class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_cart, only: %i[new create]

  def index
    customer = find_customer_for_user
    @orders = customer ? customer.orders.includes(:province, order_items: :product).order(created_at: :desc) : []
  end

  def show
    customer = find_customer_for_user
    raise ActiveRecord::RecordNotFound unless customer
    @order = customer.orders.includes(:province, order_items: :product).find(params[:id])
  end

  def new
    @province = Province.find_by(id: params[:province_id]) || current_user.province
    @street_address = params[:street_address].presence || current_user.street_address
    @city = params[:city].presence || current_user.city
    @postal_code = params[:postal_code].presence || current_user.postal_code
    calculate_totals(@province)
  end

  def create
    @province = Province.find_by(id: order_params[:province_id]) || current_user.province
    street = order_params[:street_address].presence || current_user.street_address
    city = order_params[:city].presence || current_user.city
    postal_code = order_params[:postal_code].presence || current_user.postal_code
    calculate_totals(@province)

    customer = find_or_create_customer_for_user(province: @province, street_address: street, city: city, postal_code: postal_code)
    @order = customer.orders.new(
      province: @province,
      street_address: street,
      city: city,
      postal_code: postal_code,
      status: "paid",
      subtotal: @subtotal,
      gst_rate: @gst_rate, pst_rate: @pst_rate, hst_rate: @hst_rate,
      gst_amount: @gst_amount, pst_amount: @pst_amount, hst_amount: @hst_amount,
      total: @total
    )

    Order.transaction do
      @order.save!
      @cart_items.each do |row|
        @order.order_items.create!(product: row[:product], quantity: row[:quantity], unit_price: row[:product].price)
      end
    end
    session[:cart] = {}
    redirect_to order_path(@order), notice: "Order placed successfully!"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to new_order_path, alert: "Could not place order: #{e.message}"
  end

  private

  def find_customer_for_user
    Customer.find_by(email: current_user.email)
  end

  def find_or_create_customer_for_user(province:, street_address:, city:, postal_code:)
    raw_name = current_user.username.presence || current_user.email.to_s.split("@").first.presence || "Customer"
    parts = raw_name.strip.split(/[._\s-]+/, 2)
    first_name = parts[0].presence || "Customer"
    last_name = parts[1].presence || "User"
    email = current_user.email.to_s.include?("@") ? current_user.email : "#{raw_name.gsub(/\W+/, "_")}@example.com"

    cust = Customer.find_or_initialize_by(email: email)
    cust.first_name = cust.first_name.presence || first_name
    cust.last_name = cust.last_name.presence || last_name
    cust.province = province || cust.province || Province.first
    cust.address = street_address.presence || cust.address || "N/A"
    cust.city = city.presence || cust.city || "N/A"
    cust.postal_code = postal_code.presence || cust.postal_code || "N/A"
    cust.save!
    cust
  end

  def load_cart
    cart = session[:cart] || {}
    @cart_items = cart.filter_map do |pid, qty|
      product = Product.find_by(id: pid.to_i)
      q = qty.to_i
      next if product.nil? || q <= 0
      line_total = (BigDecimal(product.price.to_s) * q).round(2)
      { product: product, quantity: q, line_total: line_total }
    end
    redirect_to cart_path, alert: "Your cart is empty." if @cart_items.empty?
  end

  def calculate_totals(province)
    @subtotal = @cart_items.sum { |row| BigDecimal(row[:line_total].to_s) }.round(2)
    @gst_rate = BigDecimal((province&.gst_rate || 0).to_s)
    @pst_rate = BigDecimal((province&.pst_rate || 0).to_s)
    @hst_rate = BigDecimal((province&.hst_rate || 0).to_s)
    @gst_amount = (@subtotal * @gst_rate).round(2)
    @pst_amount = (@subtotal * @pst_rate).round(2)
    @hst_amount = (@subtotal * @hst_rate).round(2)
    @total = (@subtotal + @gst_amount + @pst_amount + @hst_amount).round(2)
  end

  def order_params
    params.require(:order).permit(:street_address, :city, :postal_code, :province_id)
  end
end
