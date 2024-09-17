# frozen_string_literal: true

module Renalware
  module Medications
    class PrescriptionsPresenter
      include PresenterHelper
      pattr_initialize :patient

      def prescriptions
        @prescriptions ||= begin
          presenter_klass = ::Renalware::Medications::PrescriptionPresenter
          ::OpenStruct.new(
            current: present(current_non_hd_prescriptions, presenter_klass),
            recently_changed: present(recently_changed_current_prescriptions, presenter_klass),
            recently_stopped: present(recently_stopped_prescriptions, presenter_klass),
            current_hd: present(current_hd_prescriptions, presenter_klass),
            patient: patient
          )
        end
      end
      delegate :current, :recently_changed, :recently_stopped, :current_hd, to: :prescriptions

      private

      def current_non_hd_prescriptions
        @current_non_hd_prescriptions ||= current_prescriptions.where.not(administer_on_hd: true)
      end

      def current_prescriptions
        @current_prescriptions ||= patient_prescriptions.current
      end

      # Prescriptions created or with dosage changed in the last 14 days.
      # Because we terminated a prescription if the dosage changes, and create a new one,
      # we just need to search for prescriptions created in the last 14 days.
      def recently_changed_current_prescriptions
        @recently_changed_current_prescriptions ||= begin
          current_prescriptions.prescribed_between(from: 14.days.ago, to: ::Time.zone.now)
        end
      end

      # Find prescriptions terminated within 14 days
      def recently_stopped_prescriptions
        @recently_stopped_prescriptions ||= begin
          patient_prescriptions
            .terminated
            .terminated_between(from: 14.days.ago, to: ::Time.zone.now)
            .where.not(drug_id: current_prescriptions.map(&:drug_id))
        end
      end

      def current_hd_prescriptions
        @current_hd_prescriptions ||= current_prescriptions.where(administer_on_hd: true)
      end

      def patient_prescriptions
        @patient_prescriptions ||= begin
          patient
            .prescriptions
            .with_created_by
            .with_medication_route
            .with_drugs
            .with_termination
            .ordered
        end
      end
    end
  end
end
