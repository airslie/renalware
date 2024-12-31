require_relative "clinical_steps"

module Renalware
  module Clinical
    module AllergySteps
      extend WebSteps
      include ClinicalSteps

      step :create_allergies, ":user adds the following allergies to :patient"
      step :assert_allergies, ":patient has the following allergies"
      step :remove_allergy, ":user removes the :description allergy"
      step :assert_archived_allergies, ":patient has these archived allergies"
      step :mark_patient_as_having_no_known_allergies, "Clyde is able to mark Patty as having No Known Allergies"

      def create_allergies(_user_name, _patient_name, table)
        table.hashes.each do |hash|
          clinical_patient.allergies.create(
            description: hash["description"],
            recorded_at: Time.zone.now,
            by: user
          )
        end
      end

      def remove_allergy(_user_name, description)
        expect {
          clinical_patient.allergies.where(description: description).first.destroy
        }.to change { clinical_patient.allergies.count }.by(-1)
      end

      def assert_allergies(_patient_name, table)
        expected_allergies = table.hashes.pluck("description")
        actual_allergies = clinical_patient.allergies.pluck(:description)

        expect(actual_allergies && expected_allergies).to eq(expected_allergies)
      end

      def assert_archived_allergies(_patient_name, table)
        expected_allergies = table.hashes.pluck("description")
        actual_allergies = clinical_patient.allergies.only_deleted.pluck(:description)

        expect(actual_allergies).to eq(expected_allergies)
      end

      def mark_patient_as_having_no_known_allergies(*)
        status = :no_known_allergies
        patient.update_by(user, allergy_status: status)

        expect(patient.reload.allergy_status).to eq(status.to_s)
      end

      web_steps do
        def create_allergies(_user_name, _patient_name, table)
          login_as user
          po = Pages::Clinical::AllergyPage.new(patient).go

          table.hashes.each do |allergy|
            po.add_allergy(allergy["description"])
          end

          within ".clinical-allergies" do
            expect(page).to have_css(".allergy-status-form .disabled")
          end
        end

        def remove_allergy(_user_name, description)
          allergy = clinical_patient.allergies.where(description: description).first
          po = Pages::Clinical::AllergyPage.new(patient)

          po.remove_allergy(allergy)

          expect(po.exists?(allergy)).to be(false)
        end

        def mark_patient_as_having_no_known_allergies(*)
          po = Pages::Clinical::AllergyPage.new(patient)
          expect(po.status_form_disabled?).to be(true)

          po.mark_patient_as_having_no_known_allergies

          expect(clinical_patient.reload.allergy_status).to eq("no_known_allergies")
        end
      end
    end
  end
end
