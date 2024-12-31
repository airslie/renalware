module Renalware
  module Letters
    class BaseController < Renalware::BaseController
      def patient
        Letters.cast_patient(super)
      end

      private

      def load_patient
        super
        @patient = Renalware::Letters.cast_patient(@patient)
      end
    end
  end
end
