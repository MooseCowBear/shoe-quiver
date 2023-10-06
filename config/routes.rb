Rails.application.routes.draw do
  devise_for :users

  resources :shoes
  resources :runs, only: [:index, :show, :destroy, :edit, :update]

  resources :shoes do
    resources :runs, only: [:new, :create, :edit, :update]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "shoes#index"
end
