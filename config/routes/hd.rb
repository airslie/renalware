resources :patients, only: [] do
  namespace :hd do
    resource :mdm, only: :show, controller: "mdm"
    resource :dashboard, only: :show
    resource :protocol,
             only: :show,
             defaults: { format: :pdf }
    resource :preference_set, only: %i(edit update)
    resource :current_profile,
             only: %i(show edit update),
             path: "/profiles/current",
             controller: "current_profile"
    resources :historical_profiles,
              only: %i(index show),
              path: "/profiles/historical"
    resources :sessions
    resources :prescription_administrations, only: :index
    resources :vnd_risk_assessments
  end
end

namespace :hd do
  scope format: true, constraints: { format: :json } do
    get "patients_dialysing_at_unit" => "patients#dialysing_at_unit"
    get "patients_dialysing_at_hospital" => "patients#dialysing_at_hospital"
  end

  resources :prescriptions, only: [] do
    resources :administrations,
              only: %i(new create edit update destroy),
              controller: "prescription_administrations"
  end
  resources :prescription_administration, only: [] do
    resource :witness, only: %i(edit update)
  end
  resources :prescription_administration_authorisations, only: :create
  resources :transmission_logs, only: %i(show index)
  resources :slot_requests do
    collection do
      get :historical
    end
  end
  resources :cannulation_types, except: :show
  resources :dialysers, except: :show
  resources :dialysates, except: :show
  resource :ongoing_sessions, only: :show
  resources :mdm_patients, only: :index
  resources :mdm_patients, only: :index
  constraints(named_filter: /(on_worryboard)/) do
    get "mdm_patients/:named_filter", to: "mdm_patients#index", as: :filtered_mdm_patients
  end
  resources :unmet_preferences, only: :index
  resources :units, only: [] do
    resources :stations do
      post :sort, on: :collection
    end
  end
  namespace :scheduling do
    resources :units, only: [] do
      resources :diaries, only: %i(index show)
      get "diaries/:year/:week_number/edit", to: "diaries#edit", as: :edit_diary
    end
    resources :diaries, only: [] do
      resources :slots, except: :show, controller: :diary_slots
      get "slots/day/:day_of_week/period/:diurnal_period_code_id/station/:station_id",
          to: "diary_slots#show",
          as: :refresh_slot
    end
  end
  namespace :session_forms do
    resources :batches, only: %i(create show) do
      get :status, constraints: { format: :json }, defaults: { format: :json }
    end
  end
end
