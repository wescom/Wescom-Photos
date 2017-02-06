Rails.application.routes.draw do
  get 'welcome/index'
  
  resources :story_images
  resource :cart do
    put 'remove_item'
  end
  
  root 'welcome#index'

end
