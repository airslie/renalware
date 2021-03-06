# frozen_string_literal: true

module World
  module HD
    def hd_patient(patient)
      Renalware::HD.cast_patient(patient)
    end
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/hd/*.rb")]
  .sort.each { |f| require f }
