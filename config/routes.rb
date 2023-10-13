Rails.application.routes.draw do
  devise_for :users

  resources :shoes
  resources :runs, only: [:index, :show, :destroy, :edit, :update]

  resources :shoes do
    resources :runs, only: [:new, :create, :edit, :update]
  end

  resources :archive, only: [:index, :update, :destroy]
  resources :statistics, only: [:index]
  resources :units, only: [:update]

  root "shoes#index"
end
