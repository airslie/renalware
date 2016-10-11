module World
  module HD::Session
    module Domain
      # @section helpers
      #
      def hd_session_for(patient)
        patient = hd_patient(patient)

        Renalware::HD::Session.for_patient(patient).first_or_initialize
      end

      def valid_open_session_attributes(patient)
        {
          patient: patient,
          hospital_unit: Renalware::Hospitals::Unit.hd_sites.first,
          modality_description: patient.current_modality,
          start_time: Time.zone.now,
          document: {
          }
        }
      end

      def valid_closed_session_attributes(patient)
        # TODO: seed the document in a more sophisticated way!
        json = <<-END
          {"hdf": {"subs_goal": "", "subs_rate": "", "subs_volume": "", "subs_fluid_pct": ""},
          "info": {"hd_type": "hd", "machine_no": "222", "access_side": "right", "access_site":
            "Brachio-basilic & transposition", "access_type": "Arteriovenous graft (AVG)",
            "single_needle": "no", "lines_reversed": "no", "fistula_plus_line": "no",
            "dialysis_fluid_used": "a10", "is_access_first_use": "no"},
             "dialysis": {"flow_rate": 200, "blood_flow": 150,
             "machine_ktv": 1.0, "machine_urr": 1, "fluid_removed": 1.0, "venous_pressure": 1,
             "litres_processed": 1.0, "arterial_pressure": 1}, "complications":
             {"had_cramps": "no", "had_headache": "no", "had_mrsa_swab": "no",
              "had_mssa_swab": "no", "had_chest_pain": "no", "access_site_status": null,
               "was_dressing_changed": "no", "had_alteplase_urokinase": "no",
               "had_saline_administration": "no", "had_intradialytic_hypotension": "no"},
               "observations_after": {"pulse": 36, "weight": 100.0, "bm_stix": 1.0,
                "temperature": 36.0, "blood_pressure": {"systolic": 100, "diastolic": 80}},
                "observations_before": {"pulse": 67, "weight": 100.0, "bm_stix": 1.0,
                  "temperature": 36.0, "blood_pressure": {"systolic": 100, "diastolic": 80}}}
        END

        valid_open_session_attributes(patient).merge({
          end_time: "23:59",
          document: JSON.parse(json)
        })
      end

      # @section seeding
      #
      def seed_open_session_for(patient, user:, performed_on: Time.zone.today)
        patient = hd_patient(patient)
        attrs = valid_open_session_attributes(patient).merge(
            signed_on_by: user,
            by: user
          )
        attrs[:performed_on] = performed_on
        Renalware::HD::Session::Open.create(attrs)
      end

      def seed_closed_session_for(patient, user:, signed_off_by:, performed_on: Time.zone.today)
        patient = hd_patient(patient)
        attrs = valid_closed_session_attributes(patient)
        attrs[:performed_on] = performed_on

        Renalware::HD::Session::Closed.create!(
          attrs.merge(
            signed_on_by: user,
            by: user,
            signed_off_by: signed_off_by,
            end_time: attrs[:start_time] + 1.hour
          )
        )
      end

      def seed_hd_sessions(table)
        table.hashes.each do |row|
          signed_on_by = find_or_create_user(given_name: row[:signed_on_by], role: "clinician")
          signed_off_by = find_or_create_user(given_name: row[:signed_off_by], role: "clinician")
          patient = create_patient(full_name: row[:patient])

          if signed_off_by
            seed_closed_session_for(patient,
                                    user: signed_on_by,
                                    signed_off_by: signed_off_by)
          else
            seed_open_session_for(patient, user: signed_on_by)
          end
        end
      end

      # @section commands
      #
      def create_hd_session(patient:, user:, performed_on:)
        patient = hd_patient(patient)
        seed_open_session_for(patient, user: user, performed_on: performed_on)
      end

      def update_hd_session(patient:, user:)
        travel_to 1.hour.from_now

        profile = hd_session_for(patient)
        profile.update_attributes!(
          updated_at: Time.zone.now,
          end_time: profile.start_time + 1.minute,
          signed_off_by: user,
          by: user,
          document: {
          }
        )
      end

      def view_ongoing_hd_sessions(user: nil)
        @query = Renalware::HD::Sessions::OngoingQuery.new()
      end

      # @section expectations
      #
      def expect_hd_session_to_exist(patient)
        expect(Renalware::HD::Session::Open.for_patient(patient)).to be_present
      end

      def expect_hd_session_to_be_refused
        expect(Renalware::HD::Session.count).to eq(0)
      end

      def expect_hd_sessions_to_be(hashes)
        sessions = @query.call
        expect(sessions.size).to eq(hashes.size)

        entries = sessions.map do |session|
          hash = {
            patient: session.patient.to_s,
            signed_on_by: session.signed_on_by.given_name,
            signed_off_by: (session.signed_off_by.try(:given_name) || "")
          }
          hash.with_indifferent_access
        end
        hashes.each do |row|
          expect(entries).to include(row)
        end
      end
    end


    module Web
      include Domain

      def create_hd_session(user:, patient:, performed_on:)
        login_as user
        visit patient_hd_dashboard_path(patient)
        within_fieldset t_sessions(:title) do
          click_on t_sessions(:add_session)
        end

        fill_in "Session Start Time", with: "13:00"
        select hd_unit.to_s, from: "Hospital Unit"
        fill_in "Session Date", with: I18n.l(performed_on)

        within ".top" do
          click_on "Save"
        end
      end

      def update_hd_session(patient:, user:)
        login_as user
        visit patient_hd_dashboard_path(patient)

        within_fieldset "Latest HD Sessions" do
          click_on "Sign Off"
        end

        fill_in "Session End Time", with: "16:00"

        within ".top" do
          click_on "Save"
        end
      end

      def view_ongoing_hd_sessions(user:)
        login_as user
        visit hd_ongoing_sessions_path
      end

      def expect_hd_sessions_to_be(hashes)
        hashes.each do |row|
          expect(page.body).to have_content(row[:patient])
        end
      end

      private

      def t_sessions(key)
        I18n.t(key, scope: "renalware.hd.sessions.list")
      end
    end
  end
end
