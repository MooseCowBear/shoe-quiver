Rails.application.routes.draw do
  devise_for :users

  resources :shoes
  resources :runs, only: [:index, :show, :destroy, :edit, :update]

  resources :shoes do
    resources :runs, only: [:new, :create, :edit, :update]
  end

  resources :archive, only: [:index, :update, :destroy]
  resources :statistics, only: [:index]
  resource :units, only: [:update]

  root "shoes#index"

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
