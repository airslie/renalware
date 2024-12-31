resources :patients, only: [] do
  namespace :clinical do
    resource :igan_risk, only: %i(edit update)
    resources :allergies, only: %i(create destroy)
    resource :allergy_status, only: [:update]
    resource :profile, only: %i(show edit update)
    resources :dry_weights, only: %i(new create index)
    resources :body_compositions, except: :destroy
  end
end
