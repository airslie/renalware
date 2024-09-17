# frozen_string_literal: true

# TODO: mixing query and presenter here..
module Renalware
  module HD
    module Scheduling
      class DiarySlotPresenter < SimpleDelegator
        include Renalware::Engine.routes.url_helpers
        delegate :master?, to: :diary, allow_nil: true

        # Patients who prefer to dialyse on this day e.g. Mon and in this period e.g. AM.
        # Flag those already assigned so they cannot be chosen.
        def patients_preferring_to_dialyse_today_in_this_period
          patients = Renalware::HD::PatientsDialysingByDayAndPeriodQuery
            .new(diary.hospital_unit_id, day_of_week, diurnal_period_code.code)
            .call
            .all
          simplify(patients)
        end

        # Patients who prefer to dialyse on this day e.g. Mon
        # Flag those already assigned so they cannot be chosen.
        def patients_preferring_to_dialyse_today
          patients = Renalware::HD::PatientsDialysingByDayQuery
            .new(diary.hospital_unit_id, day_of_week)
            .call
            .all
          simplify(patients)
        end

        def hospital_unit
          @hospital_unit ||= Renalware::Hospitals::Unit.find(diary.hospital_unit_id)
        end

        # Return a hash that is used in two places:
        # - to build a 'patient search scope' dropdown which is displayed in the new/edit slot
        #   dialog, and 'scopes' the patient_id slimselect patient search input
        # - based on the 'patient search scope' the user chooses, we pass the relevant hash to the
        #   Patients::LookupComponent which builds the patient search input - ie we pass
        #   collection, options_url etc - to help the component build the appropriate type of input
        #   (ajax if options_url is passed, otherwise a static input using collection array etc).
        #   See Patients::LookupComponent
        def patient_search_options(edit_or_new_route_url)
          {
            dialysing_on_day_and_period: {
              text: "Dialysing #{day_of_week_name} #{diurnal_period_code.to_s.upcase}",
              collection: -> { patients_preferring_to_dialyse_today_in_this_period },
              meta: {
                data: {
                  frame_url: frame_url_for_patient_search_scope(
                    edit_or_new_route_url,
                    :dialysing_on_day_and_period
                  )
                }
              }
            },
            dialysing_on_day: {
              text: "Dialysing on #{day_of_week_name}",
              collection: -> { patients_preferring_to_dialyse_today },
              meta: {
                data: {
                  frame_url:
                    frame_url_for_patient_search_scope(edit_or_new_route_url, :dialysing_on_day)
                }
              }
            },
            dialysing_at_unit: {
              text: "All #{hospital_unit.unit_code} HD patients",
              collection: [
                [
                  "Search by patient name or NHS/hosp no.",
                  nil,
                  "data-placeholder": "true"
                ]
              ],
              options_url: hd_patients_dialysing_at_unit_path(
                unit_id: diary.hospital_unit_id,
                term: "REPLACEME",
                format: :json
              ),
              placeholder: "Search by patient name or NHS/hosp no.",
              meta: {
                data: {
                  frame_url:
                    frame_url_for_patient_search_scope(edit_or_new_route_url, :dialysing_at_unit)
                }
              }
            },
            dialysing_at_hospital: {
              text: "All HD patients",
              collection: [
                [
                  "Search by patient name or NHS/hosp no.",
                  nil,
                  "data-placeholder": "true"
                ]
              ],
              options_url: hd_patients_dialysing_at_hospital_path(term: "REPLACEME", format: :json),
              meta: {
                data: {
                  frame_url: frame_url_for_patient_search_scope(
                    edit_or_new_route_url,
                    :dialysing_at_hospital
                  )
                }
              }
            }
          }
        end

        private

        # When the 'patient_search' dropdown changes, we refresh the turbo frame using the
        # url returned by this method.
        def frame_url_for_patient_search_scope(edit_or_new_route_url, patient_search_scope)
          uri = URI.parse(edit_or_new_route_url)
          query = { patient_search_scope: patient_search_scope }
          params = URI.decode_www_form(uri.query || "") + query.to_a
          uri.query = URI.encode_www_form(params)
          uri.to_s
        end

        # Given some patients, return a 2d array for use in dropdowns
        def simplify(patients)
          patients.map do |patient|
            hd_profile = patient.hd_profile
            text = "#{patient.to_s(:long)} - " \
                   "#{hd_profile&.schedule_definition} " \
                   "#{hd_profile&.hospital_unit&.unit_code}".strip.truncate(65)
            [text, patient.id]
          end
        end
      end
    end
  end
end
