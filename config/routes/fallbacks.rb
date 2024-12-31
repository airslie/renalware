# Azure health-check sends requests like '/robots3455.txt'. Render 404 to signal we are running OK
get "/robots:id.txt", to: "system/errors#not_found_for_healthcheck", constraints: { id: /\d+/ }

# Convenience redirects reporting
resources :patients, only: [] do
  get "demographics", to: redirect("/patients/%{patient_id}")
  get "accesses", to: redirect("/patients/%{patient_id}/accesses/dashboard")
  get "access", to: redirect("/patients/%{patient_id}/accesses/dashboard")
  get "clinical", to: redirect("/patients/%{patient_id}/clinical/profile")
  get "hd", to: redirect("/patients/%{patient_id}/hd/dashboard")
  get "letters", to: redirect("/patients/%{patient_id}/letters/letters")
  get "low_clearance", to: redirect("/patients/%{patient_id}/low_clearance/dashboard")
  get "akcc", to: redirect("/patients/%{patient_id}/low_clearance/dashboard")
  get "pathology", to: redirect("/patients/%{patient_id}/pathology/observations/historical")
  get "pd", to: redirect("/patients/%{patient_id}/pd/dashboard")
  get "renal", to: redirect("/patients/%{patient_id}/renal/profile")
  get "transplants", to: redirect("/patients/%{patient_id}") # no rec or dnr specified
  get "transplants_donor", to: redirect("/patients/%{patient_id}/transplants/donor/dashboard")
  get "transplants_recipient",
      to: redirect("/patients/%{patient_id}/transplants/recipient/dashboard")
  get "virology", to: redirect("/patients/%{patient_id}/virology/dashboard")
end
