module World
  module Clinics
    def clinics_patient(patient)
      Renalware::Clinics.cast_patient(patient)
    end
  end
end

Rails.root.glob("features/support/worlds/clinics/*.rb").each { |f| require f }
