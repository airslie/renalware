# What are observations in RW?
# - clinic visit
#   - weight
#   - bp
xml = builder

xml.Observations(start: Time.zone.today.iso8601, stop: Time.zone.today.iso8601) do
  xml.comment! "Check what start and stop refer to here"
  patient.clinic_visits.includes(:updated_by).each do |visit|
    render "clinic_visit_observation",
           visit: visit,
           method: :systolic_bp,
           i18n_key: "blood_pressure.systolic",
           builder: builder

    render "clinic_visit_observation",
           visit: visit,
           method: :diastolic_bp,
           i18n_key: "blood_pressure.diastolic",
           builder: builder

    render "clinic_visit_observation",
           visit: visit,
           method: :weight,
           builder: builder
  end
end
