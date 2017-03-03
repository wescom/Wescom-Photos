Rails.application.routes.draw do
  get 'welcome/index'
  
  resources :story_images

  resource :cart do
    put 'remove_item'
  end

  resources :orders, only: [:index, :new, :create, :show] do
    get :download
  end
  
  root 'welcome#index'

end
