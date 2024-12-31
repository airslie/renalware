module Renalware
  module Transplants
    class Patient < Renalware::Patient
      has_one :current_donor_stage,
              -> { current },
              class_name: "DonorStage",
              dependent: :restrict_with_exception

      scope :with_registration_statuses, lambda {
        joins(<<-SQL.squish)
          left outer join transplant_registrations
            on transplant_registrations.patient_id = patients.id
          left outer join transplant_registration_statuses
            on (transplant_registration_statuses.registration_id = transplant_registrations.id
            and transplant_registration_statuses.terminated_on is null
            and transplant_registration_statuses.started_on <= current_date)
          left outer join transplant_registration_status_descriptions
            on transplant_registration_statuses.description_id =
              transplant_registration_status_descriptions.id
        SQL
      }

      def self.model_name = ActiveModel::Name.new(self, nil, "Patient")

      def ever_been_a_donor?
        @ever_been_a_donor ||= begin
          donor_modality = "Renalware::Transplants::DonorModalityDescription"
          modality_descriptions.exists?(type: donor_modality)
        end
      end

      def ever_been_a_recipient?
        @ever_been_a_recipient ||= begin
          recipient_modality = "Renalware::Transplants::RecipientModalityDescription"
          modality_descriptions.exists?(type: recipient_modality)
        end
      end
    end
  end
end
