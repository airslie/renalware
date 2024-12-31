require "collection_presenter"

module Renalware
  module Admissions
    class SummaryPart < Renalware::SummaryPart
      delegate :nhs_number, to: :patient, prefix: true

      def admissions
        @admissions ||= begin
          CollectionPresenter.new(
            Admissions::Admission.where(patient: patient).limit(5),
            Renalware::Admissions::AdmissionPresenter
          )
        end
      end

      def admissions_count
        title_friendly_collection_count(
          actual: admissions.size,
          total: Admissions::Admission.where(patient: patient).count
        )
      end

      def to_partial_path
        "renalware/admissions/summary_part"
      end
    end
  end
end
