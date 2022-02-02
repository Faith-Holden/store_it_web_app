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

  scope module: :items do 
    resources :items do
      resources :locations, only: [:index, :new, :create]
      resources :access_groups, only: [:index, :new, :create]
    end
  end

  scope module: :locations do 
    resources :locations do
        resources :items, only: [:index, :new, :create]
        resources :sublocations, only: [:index, :new, :create]
        resources :access_groups, only: [:index, :new, :create]
    end
  end
  
  scope module: :users do
    resources :users
  end

  scope module: :access_groups do 
    resources :access_groups do
        resources :items, only: [:index, :new, :create]
        resources :subgroups, only: [:index, :new, :create]
        resources :locations, only: [:index, :new, :create]
        resources :users, only: [:index, :new, :create]
    end
  end

  resources :user_accesses

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
