Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'


  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :account_activations, only: [:edit]

  resources :items do
    member do
      get :locations
      get :access_groups #controller method not yet defined
    end
  end
  resources :locations do
    member do
      get :items
      get :child_locations
      get :access_groups
    end
  end
  resources :users
  resources :access_groups do
    member do
      get :items
      get :locations
      get :users
    end
  end

  resources :user_accesses

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
