resources :patients, only: [] do
  resources :clinic_visits, controller: "clinics/clinic_visits" do
    resource :heidi_session, only: :show, controller: "clinics/heidi_sessions" do
      get :documents
    end
  end
  resources :appointments, controller: "clinics/patient_appointments", only: [:index]
end

resources :appointments, controller: "clinics/appointments", only: %i(new create index)
resources :clinic_visits, only: :index, controller: "clinics/visits"
resources :clinics, controller: "clinics/clinics"
resources :consultants, controller: "clinics/consultants"
