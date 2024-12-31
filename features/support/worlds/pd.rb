module World
  module PD
    def pd_patient(patient)
      Renalware::PD.cast_patient(patient)
    end
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/pd/*.rb")].each { |f| require f }
