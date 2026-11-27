ActiveAdmin.setup do |config|
  config.site_title = "Northern Trails Supply"
  config.site_title_link = "/"

  config.namespace :admin do |admin|
    admin.authentication_method = :authenticate_admin_user!
    admin.current_user_method = :current_admin_user
  end
end