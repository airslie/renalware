namespace :patients do
  get "mdms/:scope", to: "mdms#show", as: :mdms
  resources :primary_care_physicians
  resources :practices, only: [] do
    collection do
      get :search
    end
    resources :primary_care_physicians,
              only: :index,
              controller: "practices/primary_care_physicians"
  end
  resources :abridgements, only: :index
end

resources :bookmarks, controller: "patients/bookmarks"
resource :dashboard, only: :show, controller: "dashboard/dashboards"
resource :worryboard, only: :show, controller: "patients/worryboard"
resources :worry_categories, controller: "patients/worry_categories"
resources :deaths, only: :index, as: :patient_deaths, controller: "patients/deaths"

resources :patients, except: [:destroy], controller: "patients/patients" do
  collection do
    get :search
  end

  get "perspectives/bone",
      to: "patients/perspectives#show",
      id: :bone,
      as: :bone_perspective
  get "perspectives/anaemia",
      to: "patients/perspectives#show",
      id: :anaemia,
      as: :anaemia_perspective

  resource :clinical_summary, only: :show, controller: "patients/clinical_summaries"
  resource :death, only: %i(edit update), controller: "patients/deaths"
  resource :primary_care_physician,
           controller: "patients/primary_care_physician",
           only: %i(edit update destroy)

  resources :bookmarks, only: :create, controller: "patients/bookmarks"
  resources :alerts, only: %i(new create destroy), controller: "patients/alerts"
  resource :worry, only: %i(edit update create destroy), controller: "patients/worries"
  resources :attachments, controller: "patients/attachments"

  namespace :surveys do
    resource :dashboard, only: :show
  end
end
