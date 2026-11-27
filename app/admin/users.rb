ActiveAdmin.register User do
  permit_params :email, :username, :street_address, :city, :postal_code, :province_id
  remove_filter :encrypted_password, :reset_password_token, :remember_created_at, :orders
end
