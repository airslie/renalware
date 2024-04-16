# frozen_string_literal: true

module Renalware
  module HD
    class PatientsController < BaseController
      def dialysing_at_unit
        skip_authorization
        unit_id = params.fetch(:unit_id)
        patients = all_hd_patients_matching_search_term
          .eager_load(:hd_profile)
          .merge(HD::Profile.dialysing_at_unit(unit_id))
        render json: simplify(patients).to_json
      end

      def dialysing_at_hospital
        skip_authorization
        patients = all_hd_patients_matching_search_term
        render json: simplify(patients).to_json
      end

      private

      def all_hd_patients_matching_search_term
        Patients::SearchQuery.new(scope: HD::Patient.all, term: params[:term])
          .call
          .eager_load(hd_profile: [:hospital_unit, :schedule_definition])
          .include(ModalityScopes)
          .with_current_modality_of_class(HD::ModalityDescription)
      end

      def simplify(patients)
        patients.map do |patient|
          hd_profile = patient.hd_profile
          text = "#{patient.to_s(:long)} - " \
                 "#{hd_profile&.schedule_definition} " \
                 "#{hd_profile&.hospital_unit&.unit_code}".strip.truncate(65)
          { id: patient.id, text: text }
        end
      end
    end
  end
end
