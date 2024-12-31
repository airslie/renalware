# TODO: unused class
module Renalware
  module Patients
    class IdempotentCreatePatient
      attr_reader :params

      def initialize(user)
        @user = user
      end

      # TODO: Support different local_patient_id columns
      def call(params)
        patient_params = params.fetch(:patient).merge(by: @user)
        local_patient_id = patient_params.fetch(:local_patient_id)

        ::Renalware::Patient
          .create_with(patient_params)
          .find_or_create_by!(local_patient_id: local_patient_id)
      end
    end
  end
end
