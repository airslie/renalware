module World
  module Transplants::DonorWorkup
    module Domain
      # Helpers

      def donor_workup_for(patient)
        Renalware::Transplants::DonorWorkup.for_patient(patient).first_or_initialize
      end

      # Set-ups

      def set_up_doner_workup_for(patient)
        Renalware::Transplants::DonorWorkup.create!(
          patient: patient,
          document: {
            relationship: {
              donor_recip_relationship: "son_or_daughter"
            }
          }
        )
      end

      # Commands

      def create_donor_workup(user: nil, patient:)
        set_up_doner_workup_for(patient)
      end

      def update_donor_workup(patient:, user: nil, updated_at:)
        workup = donor_workup_for(patient)
        workup.update_attributes!(
          document: {
            relationship: {
              donor_recip_relationship: "son_or_daughter"
            },
            comorbidities: {
              angina: {
                status: "no"
              }
            }
          },
          updated_at: updated_at
        )
      end

      # Asserts

      def assert_donor_workup_exists(donor)
        expect(Renalware::Transplants::DonorWorkup.for_patient(donor).any?).to be_truthy
      end

      def assert_donor_workup_was_updated(patient)
        workup = Renalware::Transplants::DonorWorkup.for_patient(patient).first
        expect(workup.updated_at).to_not eq(workup.created_at)
      end
    end


    module Web
      include Domain

      def create_donor_workup(user:, patient:)
        login_as user
        visit patient_clinical_summary_path(patient)
        click_on "Transplant Donor Workup"

        select "Mother or father", from: "Relationship to Recipient"
        fill_in "Oral GTT", with: "66"

        within ".top" do
          click_on "Save"
        end
      end

      def update_donor_workup(patient:, user:, updated_at: nil)
        login_as user
        visit patient_clinical_summary_path(patient)
        click_on "Transplant Donor Workup"
        click_on "Edit"

        fill_in "Calculated Clearance", with: "193"

        within ".top" do
          click_on "Save"
        end
      end
    end
 end
end