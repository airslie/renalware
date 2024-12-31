namespace :admin do
  resources :users
  resource :dashboard, only: :show
  resource :playground, only: :show do
    scope constraints: { format: :json } do
      get :pathology_chart_data
    end
  end
  namespace :feeds do
    resources :files, only: %i(index show new create)
  end
  resource :cache, only: %i(show destroy)
  resource :config, only: %i(show destroy), controller: "config"
end
