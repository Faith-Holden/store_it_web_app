Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  resources :items
  resources :locations
  resources :users
  resources :access_groups
  resources :user_accesses

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
