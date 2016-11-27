Rails.application.routes.draw do
  root 'logins#new'

  resources :users, only: [:index, :new, :create], shallow: true do
    resources :gifts
  end

  resources :gifts

  get 'login', to: 'logins#new', as: :login
  post 'login', to: 'logins#create', as: :logins
  delete 'logout', to: 'logins#destroy', as: :logout

  get 'edit_basic_information', to: 'users#edit_basic_information'
  get 'edit_password', to: 'users#edit_password'
  patch 'update_basic_information', to: 'users#update_basic_information'
  patch 'update_password', to: 'users#update_password'
end
