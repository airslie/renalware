module World
  module HD
    def hd_patient(patient)
      Renalware::HD.cast_patient(patient)
    end
  end
end

Rails.root.glob("features/support/worlds/hd/*.rb").each { |f| require f }
