Rails.application.routes.draw do
  devise_for :users
  resources :shoes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "shoes#index"
end
