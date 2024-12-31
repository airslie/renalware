module Renalware
  module Drugs
    class DrugPolicy < BasePolicy
      def selected_drugs? = write_privileges?
      def prescribable? = write_privileges?
    end
  end
end
