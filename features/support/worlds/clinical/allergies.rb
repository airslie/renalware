module World
  module Clinics
    module Appointments
      module Domain
        def create_allergies_for(**)
          seed_allergies_for(**)
        end

        def seed_allergies_for(patient:, user:, allergies:)
          patient = clinical_patient(patient)
          allergies.each do |allergy|
            patient.allergies.create(description: allergy["description"],
                                     recorded_at: Time.zone.now,
                                     by: user)
          end
        end

        def remove_allergy_from_patient(patient:, allergy_description:, user:)
          patient = clinical_patient(patient)
          expect {
            patient.allergies.where(description: allergy_description).first.destroy
          }.to change { patient.allergies.count }.by(-1)
        end

        def expect_allergies_to_be(expected_allergies:, patient:)
          patient = clinical_patient(patient)
          expected_allergies = expected_allergies.pluck("description")
          actual_allergies = patient.allergies.map(&:description)
          expect(actual_allergies && expected_allergies).to eq(expected_allergies)
        end

        def expect_archived_allergies_to_be(expected_allergies:, patient:)
          patient = clinical_patient(patient)
          expected_allergies = expected_allergies.pluck("description")
          actual_allergies = patient.allergies.only_deleted.map(&:description)
          expect(actual_allergies).to eq(expected_allergies)
        end

        def mark_patient_as_having_no_allergies(patient:, user:)
          status = :no_known_allergies
          patient.allergy_status = status
          patient.by = user
          patient.save!
          expect(patient.reload.allergy_status).to eq(status.to_s)
        end
      end

      module Web
        def create_allergies_for(patient:, user:, allergies:)
          login_as user
          visit patient_clinical_profile_path(patient)
          allergies.each do |allergy|
            description = allergy["description"]
            within ".clinical-allergies" do
              click_on t_allergies(".add")
            end
            within "#add-allergy-modal.open" do
              fill_in "clinical_allergy_description", with: description
              click_on modal_t("btn.save")
            end
          end

          within ".clinical-allergies" do
            expect(page).to have_css(".allergy-status-form .disabled")
          end
        end

        def remove_allergy_from_patient(patient:, allergy_description:, user:)
          login_as user
          visit patient_clinical_profile_path(patient)
          patient = clinical_patient(patient)
          allergy = patient.allergies.where(description: allergy_description).first
          within ".clinical-allergies table" do
            row = page.find("tbody tr[data-allergy-id='#{allergy.id}']")
            within row do
              click_on t_allergies(".delete")
              page.driver.browser.switch_to.alert.accept
            end
          end
        end

        def expect_allergies_to_be(expected_allergies:, patient:)
          visit patient_clinical_profile_path(patient)
          within ".clinical-allergies table" do
            expect(page).to have_css("tbody tr", count: expected_allergies.count)
            expected_allergies.each do |allergy|
              expect(page).to have_content(allergy["description"])
            end
          end
        end

        def mark_patient_as_having_no_allergies(patient:, user:)
          within ".clinical-allergies" do
            expect(page).to have_no_css(".allergy-status-form .disabled")
            check(t_allergy_status(".no_known_allergies"))
            click_on t_allergy_status(".save")
          end

          expect(patient.reload.allergy_status).to eq("no_known_allergies")
        end

        private

        def t_allergies(key, scope: "renalware.clinical.allergies.list", required: false)
          translation = t(key, scope: scope)
          required ? "* #{translation}" : translation
        end

        def modal_t(key, required: false)
          t_allergies(key, scope: "renalware.clinical.allergies.new", required: required)
        end

        def t_allergy_status(key, required: false)
          t_allergies(key, scope: "renalware.clinical.allergy_statuses.form", required: required)
        end
      end
    end
  end
end
