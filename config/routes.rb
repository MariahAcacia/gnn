Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'users#home'

  resources :users

  get '/home' => 'users#home'

  resource :session, only: [:new, :create, :destroy]
  resource :saved_record, only: [:create, :destroy]
  resources :texts
  resources :videos
  resources :spotlights
  resources :givings

  get "video/search" => "videos#search_index"
  get "text/search" => "texts#search_index"
  get "spotlight/search" => "spotlights#search_index"
  get "giving/search" => "givings#search_index"

  get "login" => "sessions#new"
  get "logout" => "sessions#destroy"
  get "about" => "static_pages#about"
  get "contact" => "static_pages#contact"

end
