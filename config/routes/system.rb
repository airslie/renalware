namespace :system do
  resources :online_reference_links do
    get :search, on: :collection
  end
  resources :email_templates, only: :index
  resources :user_feedback, except: :destroy, controller: "user_feedback"
  resources :messages
  resources :downloads
  resources :view_metadata, only: %i(edit update) do
    patch :restore, on: :member
  end
  resources :nag_definitions, except: :show
  resources :api_logs, only: :index
end

match "/generate_test_internal_server_error",
      to: "system/errors#generate_test_internal_server_error",
      via: :get
resources :mock_errors, only: [:index], controller: "system/mock_errors"

devise_for :users,
           class_name: "Renalware::User",
           controllers: {
             omniauth_callbacks: "renalware/devise/omniauth_callbacks",
             registrations: "renalware/devise/registrations",
             sessions: "renalware/devise/sessions",
             passwords: "renalware/devise/passwords"
           }

# Session keepalive endpoint returning server-calculated expiry metadata.
get "/keep_session_alive" => "session_timeout#keep_session_alive", as: "keep_session_alive"

# Status page
get "/status" => "system/status#show", as: "status"

# enable mail previews in all environments
get "/rails/mailers" => "rails/mailers#index"
get "/rails/mailers/*path" => "rails/mailers#preview"
