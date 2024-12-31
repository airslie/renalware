module Renalware
  module PD
    class Patient < Renalware::Patient
      has_many :pet_adequacy_results, dependent: :restrict_with_exception
      has_many :pet_results, dependent: :restrict_with_exception
      has_many :adequacy_results, dependent: :restrict_with_exception

      def self.model_name = ActiveModel::Name.new(self, nil, "Patient")

      def treated?
        modality_descriptions.exists?(type: "Renalware::PD::ModalityDescription")
      end

      def has_ever_been_on_pd?
        @has_ever_been_on_pd ||=
          modality_descriptions.exists?(type: "Renalware::PD::ModalityDescription")
      end
    end
  end
end
