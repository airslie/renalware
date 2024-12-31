module Renalware
  module Medications
    class PrescriptionIndexPresenter
      include PresenterHelper

      rattr_initialize [:patient!, :params!]

      def treatable
        present(patient, TreatablePresenter)
      end

      def current_search
        current_prescriptions_query.search
      end

      def historical_prescriptions_search
        historical_prescriptions_query.search
      end

      def current_prescriptions_query
        @current_prescriptions_query ||=
          PrescriptionsQuery.new(
            relation: patient.prescriptions.current,
            search_params: params[:q]
          )
      end

      def current_prescriptions
        present(
          call_query(current_prescriptions_query),
          PrescriptionPresenter
        )
      end

      def historical_prescriptions_query
        @historical_prescriptions_query ||=
          PrescriptionsQuery.new(
            relation: patient.prescriptions,
            search_params: params[:q]
          )
      end

      def recently_changed_current_prescriptions
        @recently_changed_current_prescriptions ||= begin
          current_prescriptions_query
            .call
            .recently_changed
        end
      end

      def recently_changed_prescriptions
        present(
          recently_changed_current_prescriptions,
          PrescriptionPresenter
        )
      end

      # Find prescriptions terminated within 14 days.
      # Note we do not include those prescriptions which might have just had a dose change
      # so they were implicitly terminated and re-created. We only want ones which were explicitly
      # terminated.
      def recently_stopped_prescriptions
        @recently_stopped_prescriptions ||= begin
          prescriptions = historical_prescriptions_query.call
            .terminated
            .terminated_between(from: 14.days.ago, to: ::Time.zone.now)
            .where.not(drug_id: current_prescriptions.map(&:drug_id))
          present(prescriptions, PrescriptionPresenter)
        end
      end

      def call_query(query)
        query
          .call
          .with_created_by
          .with_drugs
          .with_termination
          .with_medication_route
          .with_forms
      end

      def historical_prescriptions
        present(
          call_query(historical_prescriptions_query),
          PrescriptionPresenter
        )
      end

      def drug_types
        Drugs::Type.all
      end
    end
  end
end
