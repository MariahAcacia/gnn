Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'users#home'

  resources :users

  get '/home' => 'users#home'

  resource :session, only: [:new, :create, :destroy]
  resources :texts

  get "login" => "sessions#new"
  get "logout" => "sessions#destroy"
  get "about" => "static_pages#about"
  get "contact" => "static_pages#contact"



end
