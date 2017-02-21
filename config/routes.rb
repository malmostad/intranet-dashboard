Dashboard::Application.routes.draw do

  get "/group_contacts/search" => "group_contacts#search", as: "group_contacts_search"
  resources :group_contacts

  root to: "dashboard#index"

  get "/more_feed_entries/:category/:before" => "dashboard#more_feed_entries", as: "more_feed_entries"

  get "/users/select_feeds/:category" => "users#select_feeds", as: "user_select_feeds"
  patch "/users/select_feeds/:category" => "users#update_feeds"
  patch "/users/reset_feeds/:category" => "users#reset_feeds", as: "user_reset_feeds"

  get "/users/select_shortcuts/:category" => "users#select_shortcuts", as: "user_select_shortcuts"
  patch "/users/select_shortcuts/:category" => "users#update_shortcuts"
  patch "/users/reset_shortcuts/:category" => "users#reset_shortcuts", as: "user_reset_shortcuts"
  delete "/users/shortcuts/:id" => "users#detach_shortcut", as: "users_detach_shortcut"

  patch "/users/update_status_message" => "users#update_status_message", as: "user_update_status_message"
  patch "/users/update_feed_stream_type"
  patch "/users/update_activities_multiple"
  get "/users/activities/:cmg_id" => "users#activities", as: "user_activities"
  get "/users/suggest"
  get "/users/search"
  get "/users/tags"
  get "/users" => "users#search"

  # Map username instead of user id
  get "/users/:username" => "users#show", as: "user"
  resources :users, except: [:show]
  get "/my_profile" => "users#my_profile", as: "my_profile"
  get "/my_roles" => "users#my_roles", as: "my_roles"

  # Avatars belongs to users but has its own controller
  # Stream out :username's avatar
  # Served as static files in production, check paperclip.rb and app_config.yml
  get "/users/:username/(:style)" => "avatars#show", as: "avatar"
  get "/users/:id/avatar/edit" => "avatars#edit", as: "edit_avatar"
  patch "/users/:id/avatars" => "avatars#update", as: "update_avatar"

  get "/colleagueships/search" => "colleagueships#search", as: "colleagueships_search"
  resources :colleagueships

  delete "/my_own_feeds/delete_all" => "my_own_feeds#destroy_all"

  resources :shortcuts, :roles, :languages, :skills, :activities, :feeds, :my_own_feeds, except: [:show]

  patch "/feeds/refresh_entries/:id" => "feeds#refresh_entries", as: "feeds_refresh_entries"

  get "/languages/suggest" => "languages#suggest", as: "languages_suggest"
  get "/languages/search" => "languages#search", as: "languages_search"
  get "/languages/merge/:id" => "languages#edit_merge", as: "languages_edit_merge"
  patch "/languages/merge/:id" => "languages#merge", as: "languages_merge"
  get "/skills/suggest" => "skills#suggest", as: "skills_suggest"
  get "/skills/search" => "skills#search", as: "skills_search"
  get "/skills/merge/:id" => "skills#edit_merge", as: "skills_edit_merge"
  patch "/skills/merge/:id" => "skills#merge", as: "skills_merge"
  get "/activities/suggest" => "activities#suggest", as: "activities_suggest"
  get "/activities/search" => "activities#search", as: "activities_search"
  get "/activities/merge/:id" => "activities#edit_merge", as: "activities_edit_merge"
  patch "/activities/merge/:id" => "activities#merge", as: "activities_merge"

  get 'saml/new'
  post 'saml/consume'
  get 'saml/metadata'

  get  "/login" => "sessions#new"
  post "/login" => "sessions#create"
  get  "/logout" => "sessions#destroy"

  resources :statistics do
    collection do
      get  "ldap_diff"
    end
  end

  resources :api_apps
  get "/api_apps/create_app_secret/:id" => "api_apps#create_app_secret", as: "create_app_secret"

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      get "/employees/search" => "employees#search"
      get "/employees/:id" => "employees#show", as: "employee"
      get "/group_contacts/search" => "group_contacts#search"
      get "/group_contacts/:id" => "group_contacts#show", as: "group_contact"
    end
  end

  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404', via: :all
  end
end
