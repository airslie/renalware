module Renalware
  module Letters
    class BaseController < Renalware::BaseController
      def patient
        Letters.cast_patient(super)
      end
    end
  end
end
