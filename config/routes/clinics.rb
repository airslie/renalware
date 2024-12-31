resources :patients, only: [] do
  resources :clinic_visits, controller: "clinics/clinic_visits"
end

resources :appointments, controller: "clinics/appointments", only: %i(new create index)
resources :clinic_visits, only: :index, controller: "clinics/visits"
resources :clinics, controller: "clinics/clinics"
resources :consultants, controller: "clinics/consultants"
