module World
  module Accesses
    def accesses_patient(patient)
      Renalware::Accesses.cast_patient(patient)
    end
  end
end

Rails.root.glob("features/support/worlds/accesses/*.rb").each { |f| require f }
