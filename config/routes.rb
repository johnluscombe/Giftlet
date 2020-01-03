Rails.application.routes.draw do
  root 'logins#new'

  resources :families, only: :index do
    resources :users, only: :index do
      resources :gifts, only: :index
    end
  end

  resources :users, only: :create do
    resources :gifts, only: :create
    delete 'clear_purchased_gifts'
  end

  resources :gifts, only: [:update, :destroy], param: :gift_id

  resources :gifts, only: [] do
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
