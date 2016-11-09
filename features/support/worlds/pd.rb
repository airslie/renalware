module World
  module PD
    def expect_exit_site_prescriptions_to_be_revised(patient, exit_site_infection)
      prescriptions = exit_site_infection.prescriptions.order(created_at: :asc)
      current_prescription = prescriptions.current.first

      expect(current_prescription.patient).to eq(patient)
    end
  end
end

Dir[Rails.root.join("features/support/worlds/pd/*.rb")].each { |f| require f }
