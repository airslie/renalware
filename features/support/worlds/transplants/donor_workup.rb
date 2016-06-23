module World
  module Transplants::DonorWorkup
    module Domain
      # @section helpers
      #
      def donor_workup_for(patient)
        Renalware::Transplants::DonorWorkup.for_patient(patient).first_or_initialize
      end

      # @section seeding
      #
      def seed_doner_workup_for(patient)
        Renalware::Transplants::DonorWorkup.create!(
          patient: patient,
          document: {
            comorbidities: {
              angina: {
                status: "unknown"
              }
            }
          }
        )
      end

      def seed_patient_on_wait_list(patient, status="Active")
        Renalware::Transplants::Registration.create!(
          patient: patient,
          statuses_attributes: {
            "0": {
              started_on: "03-11-2015",
              description_id: registration_status_description_named(status).id,
              by: Renalware::User.first
            }
          }
        )
      end

      # @section commands
      #
      def create_donor_workup(user: nil, patient:)
        seed_doner_workup_for(patient)
      end

      def update_donor_workup(patient:, user: nil)
        travel_to 1.hour.from_now

        workup = donor_workup_for(patient)
        workup.update_attributes!(
          document: {
            comorbidities: {
              angina: {
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
        click_on "Enter workup"

        fill_in "Oral GTT", with: "66"

        within ".top" do
          click_on "Save"
        end
      end

      def update_donor_workup(patient:, user:)
        login_as user
        visit patient_transplants_donor_workup_path(patient)
        click_on "Edit"

        fill_in "Calculated Clearance", with: "193"

        within ".top" do
          click_on "Save"
        end
      end
    end
 end
end
