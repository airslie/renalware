module World
  module Transplants
    def transplant_patient(patient)
      Renalware::Transplants.cast_patient(patient)
    end
  end
end

Rails.root.glob("features/support/worlds/transplants/*.rb").each { |f| require f }
