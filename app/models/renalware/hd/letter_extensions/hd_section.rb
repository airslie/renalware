# frozen_string_literal: true

module Renalware
  module HD
    module LetterExtensions
      class HDScheduleComponent < ViewComponent::Base
        include ActionView::Helpers

        def initialize(patient:)
          @patient = patient
        end

        def call
          output = []
          if presented_hd_profile.hospital_unit_unit_code.present?
            output << "<dt>HD Unit</dt><dd>#{presented_hd_profile.hospital_unit_unit_code}</dd>"
          end

          if presented_hd_profile.current_schedule
            output << "<dt>Schedule</dt><dd>#{presented_hd_profile.current_schedule}</dd>"
          end

          if presented_hd_profile.formatted_prescribed_time.present?
            output << "<dt>Time</dt><dd>#{presented_hd_profile.formatted_prescribed_time}</dd>"
          end

          "<dl>#{output.join}</dl>".html_safe
        end

        def render?
          hd_profile.present?
        end

        private

        def hd_profile
          @hd_profile ||= HD.cast_patient(@patient).hd_profile
        end

        def presented_hd_profile
          @presented_hd_profile ||= HD::ProfilePresenter.new(hd_profile)
        end
      end

      # Potentially rename to AccessComponent and move into Accesses::LettersExtensions
      class HDAccessComponent < ViewComponent::Base
        def initialize(patient:)
          @patient = patient
        end

        def call
          output1 = []
          output1 << "<dt>HD Access</dt>"
          sub_output1 = []
          sub_output1 << "#{presented_access_profile.type}" if presented_access_profile.type
          sub_output1 << "#{presented_access_profile.side}" if presented_access_profile.side
          output1 << "<dd>#{sub_output1.join(' ')}</dd>" if sub_output1.present?

          output2 = []
          sub_output2 = []
          sub_output2 << "#{presented_access_profile.plan_type}" if presented_access_profile.plan_type.present?
          sub_output2 << "#{::I18n.l(presented_access_profile.plan_date&.to_date)}" if presented_access_profile.plan_date.present?
          output2 << "<dd>#{sub_output2.join(' ')}</dd>" if sub_output2.present?

          "<dl>#{[output1.join(' '), output2.join(' ')].compact.join}</dl>".html_safe
        end

        def render?
          access_profile.present?
        end

        private

        def access_profile
          @access_profile ||= Accesses.cast_patient(@patient).current_profile
        end

        def presented_access_profile
          @presented_access_profile ||= Accesses::ProfilePresenter.new(access_profile)
        end
      end

      class PatientObservationsComponent < ViewComponent::Base
        def initialize(patient:)
          @patient = patient
        end

        def call
          output = []
          output << "<dt>Mean pre HD BP</dt><dd>#{mean_pre_hd_bp}</dd>" if mean_pre_hd_bp
          output << "<dt>Mean post HD BP</dt><dd>#{mean_post_hd_bp}</dd>" if mean_post_hd_bp
          output << "<dt>Dry Weight</dt><dd>#{latest_dry_weight}</dd>" if latest_dry_weight
          output << "<dt>BMI</dt><dd>#{bmi}</dd>" if bmi
          "<dl>#{output.join}</dl>".html_safe
        end

        def render?
          patient_statistics.present?
        end

        private

        def bmi
          BMI.new(height: height, weight: latest_dry_weight).to_f
        end

        def height
          @height ||= Clinics::CurrentObservations.new(@patient).height.measurement
        end

        def mean_pre_hd_bp
          return nil unless patient_statistics
          return nil unless patient_statistics.pre_mean_systolic_blood_pressure
          return nil unless patient_statistics.pre_mean_diastolic_blood_pressure

          "#{patient_statistics.pre_mean_systolic_blood_pressure.round} / #{patient_statistics.pre_mean_diastolic_blood_pressure.round}"
        end

        def mean_post_hd_bp
          return nil unless patient_statistics
          return nil unless patient_statistics.post_mean_systolic_blood_pressure
          return nil unless patient_statistics.post_mean_diastolic_blood_pressure

          "#{patient_statistics.post_mean_systolic_blood_pressure.round} / #{patient_statistics.post_mean_diastolic_blood_pressure.round}"
        end

        def patient_statistics
          @patient_statistics ||= HD.cast_patient(@patient).rolling_patient_statistics
        end

        def latest_dry_weight
          Clinical.cast_patient(@patient).latest_dry_weight&.weight
        end
      end

      class URRAndTransplantStatusComponent < ViewComponent::Base
        # http://localhost:3000/patients/5a99a85ead8f4b6c9a1e8251e4f7ce77/transplants/recipient/registration/edit

        def initialize(patient:)
          @patient = patient
        end

        def call
          output = []
          output << "<dt>Mean URR</dt><dd>#{urr_value}</dd><dd>#{urr_date}</dd>" if urr_value
          output << "<dt>Transplant status</dt><dd>#{transplant_status&.description}</dd><dd>#{::I18n.l(transplant_status&.started_on)}</dd>" if transplant_status
          "<dl>#{output.join}</dl>".html_safe
        end

        def render?
          true
        end

        private

        def urr_date
          ::I18n.l(current_observation_values.urr_observed_at)
        end

        def urr_value
          current_observation_values.urr_result
        end

        def transplant_status
          @transplant_status ||= Transplants.current_transplant_status_for_patient(@patient)
        end

        def current_observation_values
          # alternatively define a method somewhere to do the OR condition there
          @current_observation_values ||= (@patient.current_observation_set || Pathology::NullObservationSet.new).values
        end
      end

      class HDSection < ::Renalware::Letters::Section
        def to_partial_path
          "renalware/hd/letter_extensions/hd_section"
        end

        class << self
          def position
            10
          end

          def description
            "This renders the fields for ..."
          end
        end
      end
    end
  end
end
