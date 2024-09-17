# frozen_string_literal: true

module Renalware
  module Prescriptions
    class SummaryComponent < ApplicationComponent
      include ::PresenterHelper

      attr_reader :patient

      def initialize(patient:)
        @patient = patient
        super
      end

      def prescriptions
        @prescriptions ||= Medications::PrescriptionsPresenter.new(patient).prescriptions
      end
      delegate_missing_to :prescriptions

      private

      def current_non_hd
        @current_non_hd ||= current_prescriptions.where.not(administer_on_hd: true)
      end

      def current_prescriptions
        @current_prescriptions ||= patient_prescriptions.current
      end

      def recently_changed_current_prescriptions
        @recently_changed_current_prescriptions ||= current_prescriptions.recently_changed
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

      def current_hd
        @current_hd ||= current_prescriptions.where(administer_on_hd: true)
      end

      def patient_prescriptions
        @patient_prescriptions ||= begin
          patient
            .prescriptions
            .with_created_by
            .with_medication_route
            .with_units_of_measure
            .with_drugs
            .with_termination
            .ordered
        end
      end
    end
  end
end
