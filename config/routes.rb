Rails.application.routes.draw do
  resources :demo_sessions, only: [:create]
  devise_for :users

  resources :shoes
  resources :runs, only: [:index, :destroy, :edit, :update]

  resources :shoes do
    resources :runs, only: [:new, :create]
  end

  resources :archive, only: [:index, :update, :destroy]
  resources :statistics, only: [:index]
  resource :units, only: [:update]

  root "shoes#index"

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
