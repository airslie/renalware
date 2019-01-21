# frozen_string_literal: true

Renalware::Engine.routes.draw do
  match "/404", to: "system/errors#not_found", via: :all
  match "/500", to: "system/errors#internal_server_error", via: :all
  match "/generate_test_internal_server_error",
        to: "system/errors#generate_test_internal_server_error",
        via: :get

  devise_for :users,
             class_name: "Renalware::User",
             controllers: {
               registrations: "renalware/devise/registrations",
               sessions: "renalware/devise/sessions",
               passwords: "renalware/devise/passwords"
             },
             module: :devise

  # An ajax-polled route which will cause the users browser to redirect to the login page
  #  when their session expires
  get "/session_timed_out" => "session_timeout#has_user_timed_out", as: "session_timed_out"

  super_admin_constraint = lambda do |request|
    current_user = request.env["warden"].user || Renalware::NullUser.new
    current_user.has_role?(:super_admin)
  end

  constraints super_admin_constraint do
    match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]
  end

  # enable mail previews in all environments
  get "/rails/mailers" => "rails/mailers#index"
  get "/rails/mailers/*path" => "rails/mailers#preview"

  root to: "dashboard/dashboards#show"

  resources :mock_errors, only: [:index], controller: "system/mock_errors"

  namespace :reporting do
    resources :audits, except: [:destroy, :create, :new]
    resources :audit_refreshments, only: [:create]
  end

  namespace :admissions do
    resources :requests, except: :show do
      post :sort, on: :collection
    end
    resources :consults, except: :show
    resources :admissions, except: :show
  end

  namespace :messaging do
    namespace :internal do
      resources :messages, only: [:new, :create] do
        resources :receipts, only: [] do
          patch :mark_as_read, on: :member
        end
      end
      scope :messages do
        get "inbox", to: "receipts#unread", as: :inbox
        get "read", to: "receipts#read", as: :read_receipts
        get "sent", to: "receipts#sent", as: :sent_messages
      end
    end
  end

  namespace :admin do
    resources :users
    namespace :feeds do
      resources :files, only: [:index, :show, :new, :create]
    end
    resource :cache, only: [:show, :destroy]
  end

  namespace :api do
    # The UKRDC XML API
    namespace :ukrdc, defaults: { format: :xml } do
      resources :patients,
                only: :show,
                constraints: { format: :xml }
    end
    # The JSON API
    namespace :v1, constraints: { format: :json }, defaults: { format: :json } do
      resources :patients, only: [:show, :index], controller: "patients/patients" do
        resources :prescriptions, controller: "medications/prescriptions", only: [:index]
        namespace :hd do
          resource :current_profile,
                   only: :show,
                   path: "/profiles/current",
                   controller: "current_profile"
        end
      end
    end
  end

  namespace :research do
    resources :studies do
      resources :participations, controller: :participations
      resources :investigatorships, controller: :investigatorships
    end
  end

  resources :snippets, controller: "snippets/snippets", except: :show do
    resources :snippet_clones,
              controller: "snippets/snippet_clones",
              only: :create, as: :clones
    resources :snippet_invocations,
              controller: "snippets/snippet_invocations",
              only: :create,
              as: :invocations
  end

  resources :bookmarks, controller: "patients/bookmarks", only: [:destroy, :index]
  resource :dashboard, only: :show, controller: "dashboard/dashboards"
  resource :worryboard, only: :show, controller: "patients/worryboard"

  # Clinics
  resources :appointments, controller: "clinics/appointments", only: [:new, :create, :index]
  resources :clinic_visits, only: :index, controller: "clinics/visits"

  resources :deaths, only: :index, as: :patient_deaths

  namespace :directory do
    resources :people, except: [:delete] do
      collection do
        get :search
      end
    end
  end

  namespace :drugs do
    resources :drugs, except: :show do
      collection do
        scope format: true, constraints: { format: :json } do
          get :selected_drugs
        end
      end
    end
  end

  namespace :medications do
    # medications_esa_prescriptions => /medications/esa_prescriptions
    resources :esa_prescriptions,
              only: :index,
              drug_type_name: :esa,
              controller: "drug_types/prescriptions"
  end

  namespace :events do
    resources :types, except: :show
  end

  namespace :hd do
    scope format: true, constraints: { format: :json } do
      get "patients_dialysing_at_unit" => "patients#dialysing_at_unit"
      get "patients_dialysing_at_hospital" => "patients#dialysing_at_hospital"
    end

    resources :transmission_logs, only: [:show, :index]
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
      resources :diaries, only: [:index, :show]
      get "diaries/:year/:week_number/edit", to: "diaries#edit", as: :edit_diary
    end
    resources :diaries, only: [] do
      resources :slots, except: :show, controller: :diary_slots
      get "slots/day/:day_of_week/period/:diurnal_period_code_id/station/:station_id",
          to: "diary_slots#show",
          as: :refresh_slot
    end
  end

  namespace :hospitals do
    resources :units, except: :show do
      resources :wards
      scope format: true, constraints: { format: :json } do
        resources :wards, only: :index
      end
    end
  end

  namespace :modalities do
    resources :descriptions, except: [:show]
    resources :reasons, only: [:index]
  end

  namespace :letters do
    resource :pdf_letter_cache, only: [:destroy], controller: "pdf_letter_cache"
    resources :descriptions, only: :search do
      collection do
        get :search
      end
    end
    resource :list, only: :show
    resources :letters, only: [] do
      resources :electronic_receipts, only: [] do
        patch :mark_as_read, on: :member
      end
    end
    resources :electronic_receipts, only: [] do
      collection do
        get :unread
        get :read
        get :sent
      end
    end
  end
  get "authors/:author_id/letters", to: "letters/letters#author", as: "author_letters"

  namespace :pathology do
    namespace :requests do
      # NOTE: This needs to be POST since the params may exceed url char limit in GET
      post "requests/new", to: "requests#new", as: "new_request"
      resources :requests, only: [:create, :index, :show]
      resources :rules, only: :index
    end
  end

  namespace :patients do
    resources :primary_care_physicians
    resources :practices, only: [] do
      collection do
        get :search
      end
      resources :primary_care_physicians,
                only: :index,
                controller: "practices/primary_care_physicians"
    end
  end

  namespace :pd do
    resources :bag_types, except: [:show]
    resources :infection_organisms
    resources :mdm_patients, only: :index
    constraints(named_filter: /(on_worryboard)/) do
      get "mdm_patients/:named_filter", to: "mdm_patients#index", as: :filtered_mdm_patients
    end
  end

  namespace :renal do
    resources :prd_descriptions, only: [:search] do
      collection do
        get :search
      end
    end
    resources :aki_alerts, only: [:edit, :update, :index]
    resources :registry_preflight_checks, only: [] do
      collection do
        get :patients
        get :deaths
      end
    end
  end

  namespace :low_clearance do
    resources :mdm_patients, only: :index
    constraints(named_filter: /#{Renalware::LowClearance::MDM_FILTERS.join("|")}/) do
      get "mdm_patients/:named_filter", to: "mdm_patients#index", as: :filtered_mdm_patients
    end
  end

  namespace :system do
    resources :email_templates, only: :index
    resources :user_feedback, except: :destroy, controller: "user_feedback"
    resources :messages
  end

  namespace :transplants do
    constraints(named_filter: /#{Renalware::Transplants::WAITLIST_FILTERS.join("|")}/) do
      get "wait_list/:named_filter", to: "wait_lists#show", as: :wait_list
    end
    resources :live_donors, only: :index
    resources :mdm_patients, only: :index
    constraints(named_filter: /(recent|on_worryboard|past_year)/) do
      get "mdm_patients/:named_filter", to: "mdm_patients#index", as: :filtered_mdm_patients
    end
  end

  # Patient-scoped Routes
  #
  # Please add all non patient-scoped routes above
  #
  resources :patients, except: [:destroy], controller: "patients/patients" do
    collection do
      get :search
    end

    resource :clinical_summary, only: :show, controller: "patients/clinical_summaries"
    resource :death, only: [:edit, :update]
    resource :primary_care_physician,
             controller: "patients/primary_care_physician",
             only: [:edit, :update]

    resources :admissions, only: [:index], controller: "admissions/patient_admissions"

    namespace :clinical do
      resources :allergies, only: [:create, :destroy]
      resource :allergy_status, only: [:update]
      resource :profile, only: [:show, :edit, :update]
      resources :dry_weights, only: [:new, :create, :index]
      resources :body_compositions, except: :destroy
    end

    resources :bookmarks, only: :create, controller: "patients/bookmarks"
    resources :alerts, only: [:new, :create, :destroy], controller: "patients/alerts"
    resource :worry, only: [:create, :destroy], controller: "patients/worry"

    namespace :accesses do
      resource :dashboard, only: :show
      resources :assessments, except: [:index, :destroy]
      resources :procedures, except: [:index, :destroy]
      resources :profiles, except: [:index, :destroy]
      resources :plans, except: [:index, :destroy]
    end

    # Clinics
    resources :clinic_visits, controller: "clinics/clinic_visits"

    # Events
    resources :events, only: [:new, :create, :index], controller: "events/events"

    resources :swabs,
              only: [:new, :create, :edit, :update],
              controller: "events/swabs",
              defaults: { slug: :swabs }

    resources :investigations,
              only: [:new, :create, :edit, :update],
              controller: "events/investigations",
              defaults: { slug: :investigations }

    # Here we could enable new event by any other slug
    # eg patient_new_specific_event(slug: "transplant_biopsies")
    # get "events/:slug/new",
    #     to: "events/events#new",
    #     as: :new_specific_event
    # or we could hardwire routes as we do for swabs.

    namespace :hd do
      resource :mdm, only: :show, controller: "mdm"
      resource :dashboard, only: :show
      resource :protocol,
               only: :show,
               constraints: { format: /(pdf)/ },
               defaults: { format: :pdf }
      resource :preference_set, only: [:edit, :update]
      resource :current_profile,
               only: [:show, :edit, :update],
               path: "/profiles/current",
               controller: "current_profile"
      resources :historical_profiles,
                only: [:index, :show],
                path: "/profiles/historical"
      resources :sessions
    end

    # Medications
    resources :prescriptions, controller: "medications/prescriptions", except: [:destroy]
    namespace :medications do
      resources :prescriptions, only: [] do
        resource :termination, only: [:new, :create]
      end
    end

    namespace :letters do
      resources :contacts, only: [:index, :new, :create, :edit, :update]
      resources :letters do
        resource :pending_review, controller: "pending_review_letters", only: :create
        resource :rejected, controller: "rejected_letters", only: :create
        resource :approved, controller: "approved_letters", only: :create
        resource :completed, controller: "completed_letters", only: [:new, :create]
        resource :formatted, controller: "formatted_letters", only: :show
        resource :printable,
                 controller: "printable_letters",
                 only: :show,
                 constraints: { format: /(pdf)/ },
                 defaults: { format: :pdf }
        collection do
          get :contact_added
        end
      end
    end

    namespace :renal do
      resource :profile, only: [:show, :edit, :update]
    end

    # Modalities
    resources :modalities, only: [:new, :create, :index], controller: "modalities/modalities"

    namespace :pd do
      resource :dashboard, only: :show
      resources :apd_regimes,
                controller: "regimes",
                type: "PD::APDRegime",
                only: [:new, :create, :edit, :update, :show]
      resources :capd_regimes,
                controller: "regimes",
                type: "PD::CAPDRegime",
                only: [:new, :create, :edit, :update, :show]
      resources :regimes, only: [:new, :create, :edit, :update, :show]
      resources :peritonitis_episodes, only: [:new, :create, :show, :edit, :update]
      resources :exit_site_infections, only: [:new, :create, :show, :edit, :update]
      resources :pet_adequacy_results, except: [:destroy]
      resources :assessments, except: [:index, :destroy]
      resources :training_sessions, except: [:index, :destroy]
      resource :mdm, only: :show, controller: "mdm"
    end

    namespace :low_clearance do
      resource :dashboard, only: :show
      resource :profile, only: [:edit, :update]
      resource :mdm, only: :show, controller: "mdm"
    end

    member do
      get :capd_regime
      get :apd_regime
    end

    namespace :pathology do
      get "observations/current",
          to: "current_observation_results#index",
          as: "current_observations"
      get "observations/recent",
          to: "recent_observation_results#index",
          as: "recent_observations"
      get "observations/historical",
          to: "historical_observation_results#index",
          as: "historical_observations"
      resources :observation_requests, only: [:index, :show]
      resources :patient_rules
      get "descriptions/:description_id/observations",
          to: "observations#index",
          as: "observations"
      resources :required_observations, only: :index
    end

    namespace :virology do
      resource :dashboard, only: :show, path: "/dashboard"
      resource :profile, except: :destroy

      resources :vaccinations,
              only: [:new, :create, :edit, :update],
              defaults: { slug: :vaccinations }
    end

    # Problems
    resources :problems, controller: "problems/problems" do
      post :sort, on: :collection
      resources :notes, only: [:index, :new, :create], controller: "problems/notes"
    end

    namespace :transplants do
      resource :mdm, only: :show, controller: "mdm"

      scope "/donor" do
        resource :donor_dashboard, only: :show, path: "/dashboard"
        resource :donor_workup, only: [:show, :edit, :update], path: "/workup"
        resources :donor_operations, except: [:index, :destroy], path: "/operations" do
          resource :followup,
                   except: :destroy,
                   controller: "donor_followups",
                   path: "/follow_up"
        end
        resources :donations, except: [:index, :destroy]
        resource :donor_stage, only: [:new, :create], path: "/stage"
      end

      scope "/recipient" do
        resource :recipient_dashboard, only: :show, path: "/dashboard"
        resource :recipient_workup, only: [:show, :edit, :update], path: "/workup"
        resources :recipient_operations, except: [:index, :destroy], path: "/operations" do
          resource :followup,
                   except: :destroy,
                   controller: "recipient_followups",
                   path: "/follow_up"
        end
        resource :registration, only: [:show, :edit, :update] do
          resources :statuses, except: [:index, :show], controller: "registration_statuses"
        end
      end
    end
  end

  # Some safety-net routes in case we happen to fall through the above routed without a match.
  # For example, redirect to the HD dashboard if they hit just /hd/
  # In theory we should only ever hit these routes if the user manually edits/enters the URL.
  get "/patients/:id/hd", to: redirect("/patients/%{id}/hd/dashboard")
  get "/patients/:id/pd", to: redirect("/patients/%{id}/pd/dashboard")
  get "/patients/:id/transplants", to: redirect("/patients/%{id}")
  get "/patients/:id/transplants/donor",
    to: redirect("/patients/%{id}/transplants/donor/dashboard")
  get "/patients/:id/transplants/recipient",
      to: redirect("/patients/%{id}/transplants/recipient/dashboard")
end
