module Renalware
  module Clinical
    class DeleteAllergy
      def initialize(allergy, user)
        @allergy = allergy
        @user = user
      end

      def call
        Allergy.transaction do
          patient = allergy.patient
          allergy.destroy
          if patient.allergies.count.zero?
            patient.update(allergy_status: :unrecorded, by: user)
          end
        end
      end

      private

      attr_reader :allergy, :user
    end
  end
end
