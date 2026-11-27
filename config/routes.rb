Rails.application.routes.draw do
  devise_for :users
  root "products#index"

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :products, only: [:index, :show]
  resources :categories, only: [:show]

  get "/about", to: "pages#show", defaults: { slug: "about" }, as: :about
  get "/contact", to: "pages#show", defaults: { slug: "contact" }, as: :contact 
  get "/cart", to: "carts#show", as: :cart
  post "/cart/add/:product_id", to: "carts#add", as: :add_item_cart
  patch "/cart/items/:product_id", to: "carts#update", as: :update_item_cart
  delete "/cart/items/:product_id", to: "carts#remove", as: :remove_from_cart

  resources :orders, only: [:index, :new, :create, :show]
  resource :cart, only: [:show]
  resources :cart_items, only: [:create, :update, :destroy]
end
