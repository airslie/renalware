require "collection_presenter"

module Renalware
  module Admissions
    class ConsultSummaryPart < Renalware::SummaryPart
      delegate :nhs_number, to: :patient, prefix: true

      def consults
        @consults ||= begin
          CollectionPresenter.new(
            Admissions::Consult
              .where(patient: patient)
              .includes(:created_by, :hospital_ward, :patient)
              .order(started_on: :desc)
              .limit(5),
            Renalware::Admissions::ConsultPresenter
          )
        end
      end

      def consults_count
        title_friendly_collection_count(
          actual: consults.size,
          total: Admissions::Consult.where(patient: patient).count
        )
      end

      def to_partial_path
        "renalware/admissions/consults/summary_part"
      end
    end
  end
end
