Rails.application.routes.draw do
  root 'logins#new'

  resources :users, only: [:index, :new, :create], shallow: true do
    resources :gifts, only: [:index, :create, :update, :destroy]
  end

  resources :gifts, only: [:index, :create, :update, :destroy] do
    patch 'mark_as_purchased'
    patch 'mark_as_unpurchased'
  end

  get 'login', to: 'logins#new', as: :login
  post 'login', to: 'logins#create', as: :logins
  delete 'logout', to: 'logins#destroy', as: :logout

  patch 'update_basic_information', to: 'users#update_basic_information'
  patch 'update_password', to: 'users#update_password'

  get 'about', to: 'about#index'
end
