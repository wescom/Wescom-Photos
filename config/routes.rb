Rails.application.routes.draw do

  get 'home/index'
  
  resources :locations, :only => [:index, :edit, :update, :show]
  resources :story_images , :path => 'images', :only => [:index, :show] do
    put 'approve_forsale'
  end
  resources :pdf_images , :path => 'pdfs', :only => [:index]

  resource :cart do
    put 'remove_item'
    post 'add_pdf'
  end

  resources :orders, only: [:index, :new, :create, :show] do
    get :download
  end
  match  "/dashboard" => "orders#dashboard", :via => [:get]
  
  resources :default_settings
  resources :default_banner_images, :only => [:new, :create, :destroy]
  resources :default_pages
  
  resources :sessions
  match "/login" => "sessions#new", :via => [:get, :post]
  match "/logout" => "sessions#destroy", :via => [:get, :post]
  match "/adauth" => "sessions#create", :via => [:get, :post]
  match "/admin" => "sessions#new", :via => [:get, :post]

  root 'home#index'

end
