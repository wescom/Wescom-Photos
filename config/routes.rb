Rails.application.routes.draw do

  get 'home/index'
  
  resources :locations, :only => [:index, :edit, :update, :show]
  resources :story_images , :path => 'images', :only => [:index, :show] do
    put 'approve_forsale'
  end
  resources :pdf_images , :path => 'pdfs', :only => [:index, :show]

  resource :cart do
    put 'remove_item'
    post 'add_pdf'
  end

  resources :orders, only: [:index, :new, :create, :edit, :update, :show] do
    get :order_complete
    get :admin_download
    get :resend_order_email, to: 'orders#resend_order_email', as: :resend_order_email
    resources :order_items, only: [] do
      get 'download', to: 'orders#download', as: 'download'
    end
  end
  match  "/dashboard" => "orders#dashboard", :via => [:get]
  match  "/image_report" => "orders#image_report", :via => [:get]
  match  "/email_previous_month_orders" => "orders#email_previous_month_orders", :via => [:get]
  
  resources :default_settings
  resources :default_pricings, :only => [:new, :create, :edit, :update, :destroy]
  resources :default_banner_images, :only => [:new, :create, :edit, :update, :destroy]
  resources :default_pages

  # Widget Routes
  resources :widgets, only: [:index] do
    collection do
      get 'story_images'
      get 'pdf_images'
    end
  end
  
  # Auth Routes
  resources :sessions
  match "/login" => "sessions#new", :via => [:get, :post]
  match "/logout" => "sessions#destroy", :via => [:get, :post]
  match "/adauth" => "sessions#create", :via => [:get, :post]
  match "/admin" => "sessions#new", :via => [:get, :post]

  root 'home#index'

end
