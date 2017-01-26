Rails.application.routes.draw do
  get 'welcome/index'
  
  resources 'story_images'

  root 'welcome#index'
end
