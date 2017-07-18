Rails.application.routes.draw do

  get 'home/index'
  
  resources :locations, :only => [:index, :edit, :update, :show]
  resources :story_images , :path => 'images', :only => [:index, :show]
  resources :pdf_images , :path => 'pdfs', :only => [:index, :show]

  resource :cart do
    put 'remove_item'
    post 'add_pdf'
  end

  resources :orders, only: [:index, :new, :create, :show] do
    get :download
  end
  match  "/dashboard" => "orders#dashboard", :via => [:get]
  
  resources :default_settings, only: [:index, :edit, :update]
  
  resources :sessions
  match "/login" => "sessions#new", :via => [:get, :post]
  match "/logout" => "sessions#destroy", :via => [:get, :post]
  match "/adauth" => "sessions#create", :via => [:get, :post]
  match "/admin" => "sessions#new", :via => [:get, :post]

  root 'home#index'

end
