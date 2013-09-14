Dashboard::Application.routes.draw do

  root to: "dashboard#index"

  get "/more_feed_entries/:category/:before" => "dashboard#more_feed_entries", as: "more_feed_entries"

  get "/users/select_feeds/:category" => "users#select_feeds", as: "user_select_feeds"
  put "/users/select_feeds/:category" => "users#update_feeds"
  put "/users/reset_feeds/:category" => "users#reset_feeds", as: "user_reset_feeds"
  get "/users/select_shortcuts/:category" => "users#select_shortcuts", as: "user_select_shortcuts"
  put "/users/select_shortcuts/:category" => "users#update_shortcuts"
  put "/users/reset_shortcuts/:category" => "users#reset_shortcuts", as: "user_reset_shortcuts"
  put "/users/update_status_message" => "users#update_status_message", as: "user_update_status_message"
  get "/users/activities/:cmg_id" => "users#activities", as: "user_activities"

  # Avatars belongs to users but has its own controller
  resources :avatars
  # Stream out :username's avatar
  get "/users/:username/avatars/(:style)" => "avatars#show", as: "user_avatar"

  # Map username instead of user id
  get "/users/:username" => "users#show", as: "user"
  resources :users, except: [:show]
  get "/my_profile" => "users#my_profile", as: "my_profile"
  get "/my_roles" => "users#my_roles", as: "my_roles"

  get "/colleagueships/search" => "colleagueships#search", as: "colleagueships_search"
  resources :colleagueships

  delete "/my_own_feeds/delete_all" => "my_own_feeds#destroy_all"

  resources :shortcuts, :roles, :languages, :skills, :feeds, :my_own_feeds, except: [:show]
  resources :switchboard_changes, only: [:new, :create]

  get "/languages/suggest" => "languages#suggest", as: "languages_suggest"
  get "/skills/suggest" => "skills#suggest", as: "skills_suggest"
  get "/skills/search" => "skills#search", as: "skills_search"

  get  "/search" => "site_search#index"
  get  "/search/autocomplete" => "site_search#autocomplete", as: "site_search_autocomplete"

  get 'saml/new'
  post 'saml/consume'
  get 'saml/metadata'

  get  "/login" => "sessions#new"
  post "/login" => "sessions#create"
  get  "/logout" => "sessions#destroy"

  # Catch everything else. "a" is the path in Rails 3's routing
  match '*a', to: 'application#not_found', format: false
end
