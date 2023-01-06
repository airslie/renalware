# frozen_string_literal: true

module Renalware
  module PD
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :pet_adequacy_results, dependent: :restrict_with_exception
      has_many :pet_results, dependent: :restrict_with_exception
      has_many :adequacy_results, dependent: :restrict_with_exception

      def treated?
        modality_descriptions.exists?(type: "Renalware::PD::ModalityDescription")
      end

      # rubocop:disable Naming/PredicateName
      def has_ever_been_on_pd?
        @has_ever_been_on_pd ||=
          modality_descriptions.exists?(type: "Renalware::PD::ModalityDescription")
      end
      # rubocop:enable Naming/PredicateName
    end
  end
end
