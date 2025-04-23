Rails.application.routes.draw do
  get "home/index"
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  get "orders/new"
  get "orders/create"
  get "orders/show"
  get "carts/index"
  get "carts/add_to_cart"
  get "carts/remove_from_cart"
  get "carts/update_cart"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  resources :products

  resources :categories

  resources :users

  resource :cart, only: [:show] do
    post 'add_to_cart/:product_id', to: 'carts#add_to_cart', as: 'add_to_cart'
    delete 'remove_from_cart/:product_id', to: 'carts#remove_from_cart', as: 'remove_from_cart'
    patch 'update_cart/:product_id', to: 'carts#update_cart', as: 'update_cart'
  end

  resources :orders, only: [:index, :new, :create, :show, :update, :destroy] do
    member do
      get 'thank_you'
      patch 'confirm_payment'
    end
  end

  get "/checkout", to: "orders#new"

  root "home#index"
end
