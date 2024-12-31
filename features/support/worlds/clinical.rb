module World
  module Clinical
    def clinical_patient(patient)
      Renalware::Clinical.cast_patient(patient)
    end
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/clinical/*.rb")].each { |f| require f }
