Rails.application.routes.draw do
  root 'static_pages#index'

  resources :shifts

  devise_for :users
end
