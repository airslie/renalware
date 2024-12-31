module World
  module Transplants::DonorWorkup
    module Domain
      # @section helpers
      #
      def donor_workup_for(patient)
        patient = transplant_patient(patient)

        Renalware::Transplants::DonorWorkup.for_patient(patient).first_or_initialize
      end

      # @section seeding
      #
      def seed_donor_workup_for(patient)
        patient = transplant_patient(patient)
        Renalware::Transplants::DonorWorkup.create!(
          patient: patient,
          document: {
            comorbidities: {
              diabetes: {
                status: "unknown"
              }
            }
          }
        )
      end

      # @section commands
      #
      def create_donor_workup(patient:, user: nil)
        seed_donor_workup_for(patient)
      end

      def update_donor_workup(patient:, user: nil)
        travel_to 1.hour.from_now

        workup = donor_workup_for(patient)
        workup.update!(
          document: {
            comorbidities: {
              diabetes: {
                status: "no"
              }
            }
          },
          updated_at: Time.zone.now
        )
      end

      # @section expectations
      #
      def expect_donor_workup_to_exist(donor)
        expect(Renalware::Transplants::DonorWorkup.for_patient(donor)).to be_present
      end

      def expect_donor_workup_to_be_modified(patient)
        workup = Renalware::Transplants::DonorWorkup.for_patient(patient).first
        expect(workup).to be_modified
      end
    end

    module Web
      include Domain

      def create_donor_workup(user:, patient:)
        login_as user
        visit patient_transplants_donor_dashboard_path(patient)
        within ".page-heading" do
          click_on t("btn.add_")
          click_on "Donor Workup"
        end

        fill_in "Oral GTT", with: "66"

        within ".form-actions", match: :first do
          click_on t("btn.create")
        end
      end

      def update_donor_workup(patient:, user:)
        login_as user
        visit patient_transplants_donor_workup_path(patient)
        click_on t("btn.edit")

        fill_in "Calculated Clearance", with: "193"

        within ".form-actions", match: :first do
          click_on t("btn.save")
        end
      end
    end
  end
end
