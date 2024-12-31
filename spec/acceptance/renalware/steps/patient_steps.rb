# Some steps might be just a FactoryBot.create eg Given Patty is a patient
# Other wil drop into Domain or Web worlds depending
module Renalware
  module PatientSteps
    attr_reader :patient

    step :create_patient, ":name is a patient"

    def create_patient(name)
      @patient = FactoryBot.create(:patient, given_name: name)
    end
  end
end
