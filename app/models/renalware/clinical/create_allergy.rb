require "success"
require "failure"

module Renalware
  module Clinical
    class CreateAllergy
      def initialize(patient, user)
        @patient = patient
        @user = user
      end

      def call(params)
        allergy = build_allergy(params)
        yield allergy if block_given?
        if allergy.valid?
          save_allergy(allergy)
          ::Success.new(allergy)
        else
          ::Failure.new(allergy)
        end
      end

      private

      attr_reader :patient, :user

      def build_allergy(params)
        params[:by] = user
        params[:recorded_at] ||= Time.zone.now
        patient.allergies.build(params)
      end

      def save_allergy(allergy)
        Allergy.transaction do
          allergy.save!
          unless patient.allergy_status.to_sym == :known_allergies
            patient.allergy_status = :known_allergies
            patient.allergy_status_updated_at = Time.zone.now
            patient.by = user
            patient.save!
          end
        end
      end
    end
  end
end
