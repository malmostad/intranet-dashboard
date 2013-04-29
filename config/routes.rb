Dashboard::Application.routes.draw do
  resources :feeds
  resources :users
  get "/register" => "users#new"
  get "/login" => "sessions#new"
  get "/logout" => "sessions#destroy"
  get "/change_user" => "sessions#destroy_and_login"
  post "/login" => "sessions#create"
  get "/dashboard/cal" => "dashboard#cal"
  root :to => "dashboard#index"
end
