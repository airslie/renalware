resources :patients, only: [] do
  namespace :low_clearance do
    resource :dashboard, only: :show
    resource :profile, only: %i(edit update)
    resource :mdm, only: :show, controller: "mdm"
  end
end

namespace :low_clearance do
  resources :mdm_patients, only: :index
  constraints(named_filter: /#{Renalware::LowClearance::MDM_FILTERS.join("|")}/) do
    get "mdm_patients/:named_filter", to: "mdm_patients#index", as: :filtered_mdm_patients
  end
end
