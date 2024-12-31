module Renalware
  module HD
    module LetterExtensions
      class ObservationsComponent < ViewComponent::Base
        pattr_initialize [:patient!]

        # rubocop:disable Rails/OutputSafety
        def call
          output = []
          output << "<dt>Mean pre HD BP</dt><dd>#{mean_pre_hd_bp}</dd>" if mean_pre_hd_bp
          output << "<dt>Mean post HD BP</dt><dd>#{mean_post_hd_bp}</dd>" if mean_post_hd_bp
          output << "<dt>Dry Weight</dt><dd>#{latest_dry_weight}</dd>" if latest_dry_weight
          output << "<dt>BMI</dt><dd>#{bmi}</dd>" if bmi
          "<dl>#{output.join}</dl>".html_safe
        end
        # rubocop:enable Rails/OutputSafety

        def render?
          patient_statistics.present?
        end

        private

        def bmi
          BMI.new(height: height, weight: latest_dry_weight).to_f
        end

        def height
          @height ||= Clinics::CurrentObservations.new(patient).height.measurement
        end

        # rubocop:disable Layout/LineLength
        def mean_pre_hd_bp
          return nil unless patient_statistics
          return nil unless patient_statistics.pre_mean_systolic_blood_pressure
          return nil unless patient_statistics.pre_mean_diastolic_blood_pressure

          "#{patient_statistics.pre_mean_systolic_blood_pressure.round} / #{patient_statistics.pre_mean_diastolic_blood_pressure.round}"
        end
        # rubocop:enable Layout/LineLength

        # rubocop:disable Layout/LineLength
        def mean_post_hd_bp
          return nil unless patient_statistics
          return nil unless patient_statistics.post_mean_systolic_blood_pressure
          return nil unless patient_statistics.post_mean_diastolic_blood_pressure

          "#{patient_statistics.post_mean_systolic_blood_pressure.round} / #{patient_statistics.post_mean_diastolic_blood_pressure.round}"
        end
        # rubocop:enable Layout/LineLength

        def patient_statistics
          @patient_statistics ||= HD.cast_patient(patient).rolling_patient_statistics
        end

        def latest_dry_weight
          Clinical.cast_patient(patient).latest_dry_weight&.weight
        end
      end
    end
  end
end
