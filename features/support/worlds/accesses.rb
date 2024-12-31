module World
  module Accesses
    def accesses_patient(patient)
      Renalware::Accesses.cast_patient(patient)
    end
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/accesses/*.rb")].each { |f| require f }
