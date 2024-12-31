module World
  module Patients
    module PrimaryCarePhysician
      module Domain
        def assign_primary_care_physician_to(patient, primary_care_physician:, user:)
          patient.primary_care_physician = primary_care_physician
          patient.save!
        end

        def expect_patient_primary_care_physician_to_be(primary_care_physician, patient:)
          expect(patient.primary_care_physician).to eq(primary_care_physician)
        end
      end

      module Web
        def assign_primary_care_physician_to(patient, primary_care_physician:, user:)
          login_as user
          visit patient_path(patient)

          expect(page.all(".finda-a-gp").length).to eq(0)

          find(".change-gp").click

          # check modal is visible - could make a generic fn to check a modal is showing?
          expect(page).to have_css(".finda-a-gp")

          # TODO: Work out to populate the select2 search box
          # within(".finda-a-gp") do
          #   fill_in ".select2-search__field", with: "QUE"
          #   select2 "QUE", from: select_name
          # end
        end

        def expect_patient_primary_care_physician_to_be(primary_care_physician, patient:); end
      end
    end
  end
end
