ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }
  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Store Summary" do
          ul do
            li "Products: #{Product.count}"
            li "Categories: #{Category.count}"
            li "Customers: #{User.count}"
            li "Orders: #{Order.count}"
          end
        end
      end
      column do
        panel "Recent Orders" do
          table_for Order.order(created_at: :desc).limit(5) do
            column("Order") { |order| link_to("##{order.id}", admin_order_path(order)) }
            column("Customer") { |order| order.user&.email }
            column("Status", &:status)
            column("Total") { |order| number_to_currency(order.total) }
          end
        end
      end
    end
  end
end
