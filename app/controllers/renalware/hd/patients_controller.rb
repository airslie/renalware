# frozen_string_literal: true

module Renalware
  module HD
    class PatientsController < BaseController
      after_action :track_action, only: []

      def dialysing_at_unit
        patients = Patients::SearchQuery.new(
          scope: all_hd_patients.merge(HD::Profile.dialysing_at_unit(unit_id)),
          term: search_term
        ).call
        authorize patients
        render json: patients_json(patients)
      end

      def dialysing_at_hospital
        patients = Patients::SearchQuery.new(
          scope: all_hd_patients,
          term: search_term
        ).call
        authorize patients
        render json: patients_json(patients)
      end

      private

      def unit_id     = params.fetch(:unit_id)
      def search_term = params[:term]

      def all_hd_patients
        HD::Patient
          .include(ModalityScopes)
          .with_current_modality_of_class(HD::ModalityDescription)
          .eager_load(:hd_profile)
          .includes(hd_profile: [:hospital_unit, :schedule_definition])
          .select(:id, :family_name, :given_name, :nhs_number)
      end

      def patients_json(patients)
        patients.map do |patient|
          { value: patient.id, text: patient_string(patient) }
        end.to_json
      end

      def patient_string(patient)
        profile = patient.hd_profile
        profile_info = [
          profile&.schedule_definition,
          profile&.hospital_unit&.unit_code
        ].compact_blank.join(" ")
        [
          patient.to_s(:long),
          profile_info
        ].compact_blank.join(" - ").strip.truncate(65)
      end
    end
  end
end
