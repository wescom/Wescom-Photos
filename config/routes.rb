Rails.application.routes.draw do

  get 'home/index'
  
  resources :locations, :only => [:index, :edit, :update, :show]
  resources :story_images , :path => 'images', :only => [:index, :show]

  resource :cart do
    put 'remove_item'
  end

  resources :orders, only: [:index, :new, :create, :show] do
    get :download
  end
  
  resources :default_settings, only: [:index, :edit, :update]
  match  "/dashboard" => "default_settings#dashboard", :via => [:get]
  
  resources :sessions
  match "/login" => "sessions#new", :via => [:get, :post]
  match "/logout" => "sessions#destroy", :via => [:get, :post]
  match "/adauth" => "sessions#create", :via => [:get, :post]
  match "/admin" => "sessions#new", :via => [:get, :post]

  root 'home#index'

end
