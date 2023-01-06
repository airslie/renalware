# frozen_string_literal: true

# TODO: mixing query and presenter here..
module Renalware
  module HD
    module Scheduling
      class DiarySlotPresenter < SimpleDelegator
        delegate :master?, to: :diary, allow_nil: true

        # Patients who prefer to dialyse on this day e.g. Mon and in this period e.g. AM.
        # Flag those already assigned so they cannot be chosen.
        def patients_preferring_to_dialyse_today_in_this_period
          patients = Renalware::HD::PatientsDialysingByDayAndPeriodQuery
            .new(
              diary.hospital_unit_id,
              day_of_week,
              diurnal_period_code.code
            ).call.all
          simplify(patients)
        end

        # Patients who prefer to dialyse on this day e.g. Mon
        # Flag those already assigned so they cannot be chosen.
        def patients_preferring_to_dialyse_today
          patients = Renalware::HD::PatientsDialysingByDayQuery
          .new(
            diary.hospital_unit_id,
            day_of_week
          ).call.all
          simplify(patients)
        end

        # rubocop:disable Metrics/MethodLength
        def patient_search_options
          hospital_unit = Renalware::Hospitals::Unit.find(diary.hospital_unit_id)
          [
            OpenStruct.new(
              id: :dialysing_on_day_and_period,
              name: "Dialysing #{day_of_week_name} #{diurnal_period_code.to_s.upcase}"
            ),
            OpenStruct.new(
              id: :dialysing_on_day,
              name: "Dialysing on #{day_of_week_name}"
            ),
            OpenStruct.new(
              id: :dialysing_at_unit,
              name: "All #{hospital_unit.unit_code} HD patients"
            ),
            OpenStruct.new(
              id: :dialysing_at_hospital,
              name: "All HD patients"
            )
          ]
        end
        # rubocop:enable Metrics/MethodLength

        private

        def simplify(patients)
          patients.map do |patient|
            hd_profile = patient.hd_profile
            text = "#{patient.to_s(:long)} - " \
                  "#{hd_profile&.schedule_definition} " \
                  "#{hd_profile&.hospital_unit&.unit_code}".strip.truncate(65)
            OpenStruct.new(id: patient.id, text: text)
          end
        end
      end
    end
  end
end
