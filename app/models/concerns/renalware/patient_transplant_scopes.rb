module Renalware
  module PatientTransplantScopes
    extend ActiveSupport::Concern

    included do
      ransacker :transplant_registration_status do
        Arel.sql("transplant_registration_status_descriptions.name")
      end
    end

    class_methods do
      def with_registration_statuses
        merge(Transplants::Patient.with_registration_statuses)
      end

      # Make sure we whitelist the ransackers defined above
      def ransackable_attributes(*) = super + _ransackers.keys
    end
  end
end
