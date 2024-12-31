resources :patients, only: [] do
  namespace :pd do
    resource :dashboard, only: :show
    resources :apd_regimes,
              controller: "regimes",
              type: "PD::APDRegime",
              only: %i(new create edit update show index)
    resources :capd_regimes,
              controller: "regimes",
              type: "PD::CAPDRegime",
              only: %i(new create edit update show index)
    resources :regimes, only: %i(new create edit update show)
    resources :peritonitis_episodes, only: %i(new create show edit update)
    resources :exit_site_infections, only: %i(new create show edit update)
    resources :pet_adequacy_results, except: [:destroy]
    resources :unified_pet_adequacies, only: %i(new create)
    resources :pet_results
    resources :adequacy_results
    resources :assessments, except: %i(index destroy)
    resources :training_sessions, except: %i(index destroy)
    resource :mdm, only: :show, controller: "mdm"
  end
end

namespace :pd do
  resources :pet_completions, only: :index
  resources :adequacy_completions, only: :index
  resources :bag_types, except: [:show]
  resources :infection_organisms
  resources :mdm_patients, only: :index
  constraints(named_filter: /(on_worryboard)/) do
    get "mdm_patients/:named_filter", to: "mdm_patients#index", as: :filtered_mdm_patients
  end
end
