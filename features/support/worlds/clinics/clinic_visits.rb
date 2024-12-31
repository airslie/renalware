module World
  module Clinics
    module ClinicVisits
      module Domain
        # @section helpers
        #
        def clinic_visit_for(patient)
          patient = clinics_patient(patient)
          patient.clinic_visits.first!
        end

        # @section commands
        #
        def create_clinic_visit(patient, user)
          clinic = Renalware::Clinics::Clinic.find_by(name: "Access")
          patient = Renalware::Clinics.cast_patient(patient)
          Renalware::Clinics::ClinicVisit.create(
            patient: patient,
            clinic: clinic,
            date: Time.zone.now,
            height: 1.7,
            weight: 71,
            systolic_bp: 112,
            diastolic_bp: 71,
            standing_systolic_bp: 108,
            standing_diastolic_bp: 67,
            pulse: 100,
            temperature: 37.3,
            did_not_attend: false,
            notes: "Notes",
            admin_notes: "Admin notes",
            created_by: user,
            updated_by: user
          )
        end

        def record_clinic_visit(patient, user)
          create_clinic_visit(patient, user)
        end

        def update_clinic_visit(clinic_visit, _patient, user)
          clinic = Renalware::Clinics::Clinic.find_by(name: "AKI")
          clinic_visit.update(
            clinic: clinic,
            height: 1.71,
            weight: 75.0,
            pulse: 101,
            temperature: 37.7,
            did_not_attend: false,
            notes: "Updated notes",
            admin_notes: "Updated admin notes",
            by: user
          )
        end

        # @section expectations
        #
        def expect_clinic_visit_to_exist(patient)
          patient = Renalware::Clinics.cast_patient(patient)
          expect(patient.clinic_visits.length).to eq(1)
        end

        def expect_clinic_visit_to_be_updated(clinic_visit)
          clinic_visit = Renalware::Clinics::ClinicVisit.find(clinic_visit.id)
          expected_clinic = Renalware::Clinics::Clinic.find_by(name: "AKI")

          expect(clinic_visit.clinic_id).to eq(expected_clinic.id)
          expect(clinic_visit.height).to eq(1.71)
          expect(clinic_visit.weight).to eq(75)
          expect(clinic_visit.pulse).to eq(101)
          expect(clinic_visit.temperature).to eq(37.7)
          expect(ActionView::Base.full_sanitizer.sanitize(clinic_visit.notes))
            .to eq("Updated notes")
          expect(clinic_visit.admin_notes).to eq("Updated admin notes")
        end
      end

      module Web
        include Domain

        def record_clinic_visit(patient, user)
          login_as user

          visit new_patient_clinic_visit_path(patient_id: patient)

          within ".document" do
            fill_in "Date", with: "20-07-2015"
            slim_select "Access", from: "Clinic"
            fill_in "Height", with: "1.78"
            fill_in "Weight", with: "82.5"
            fill_in "Pulse", with: "100"
            fill_in "Temperature", with: "37.3"
            fill_in "Blood Pressure", with: "110/75"
            fill_in "Standing BP", with: "107/71"
            find("trix-editor").set("Notes")
            find("textarea[name='clinic_visit[admin_notes]']").set("Admin notes")

            click_on t("btn.create")
          end
        end

        def update_clinic_visit(clinic_visit, patient, user)
          login_as user

          visit edit_patient_clinic_visit_path(
            patient_id: patient,
            id: clinic_visit.id
          )
          slim_select "AKI", from: "Clinic"
          fill_in "Height", with: "1.71"
          fill_in "Weight", with: "75"
          fill_in "Pulse", with: "101"
          fill_in "Temperature", with: "37.7"
          fill_in "Blood Pressure", with: "128/95"
          fill_in "Standing BP", with: "124/92"
          find("trix-editor").set("Updated notes")
          # find("textarea[name='clinic_visit[notes]']").set("Updated notes")
          find("textarea[name='clinic_visit[admin_notes]']").set("Updated admin notes")

          submit_form
        end
      end
    end
  end
end
