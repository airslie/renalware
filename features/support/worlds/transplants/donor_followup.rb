module World
  module Transplants::DonorFollowup
    module Domain
      # @section helpers
      #
      def donor_followup_for(operation)
        operation.followup
      end

      def valid_donor_followup_attributes
        {
          last_seen_on: Time.zone.today
        }
      end

      # @section seeding
      #
      def seed_donor_followup(operation)
        Renalware::Transplants::DonorFollowup.create!(
          valid_donor_followup_attributes.merge(
            operation: operation
          )
        )
      end

      # @section commands
      #
      def create_donor_followup(operation:, user:)
        Renalware::Transplants::DonorFollowup.create(
          valid_donor_followup_attributes.merge(
            operation_id: operation.id
          )
        )
      end

      def update_donor_followup(operation:, user: nil)
        travel_to 1.hour.from_now

        operation = donor_followup_for(operation)
        operation.update!(
          updated_at: Time.zone.now
        )
      end

      # @section expectations
      #
      def expect_donor_followup_to_exist(operation)
        expect(operation.followup).to be_present
      end

      def expect_update_donor_followup_to_succeed(operation:, user:)
        update_donor_followup(operation: operation, user: user)
        followup = donor_followup_for(operation)
        expect(followup).to be_modified
      end
    end

    module Web
      include Domain

      def create_donor_followup(operation:, user:)
        login_as user
        visit patient_transplants_donor_dashboard_path(operation.patient)
        within_article "Donor Transplant Operations" do
          click_on "Enter details"
        end

        fill_in "Last Seen Date", with: valid_donor_followup_attributes[:last_seen_on]

        within ".form-actions", match: :first do
          click_on t("btn.create")
        end
      end

      def update_donor_followup(operation:, user:)
        login_as user
        visit patient_transplants_donor_dashboard_path(operation.patient)
        within_article "Donor Transplant Operations" do
          click_on t("btn.update")
        end

        within ".transplants_donor_followup_lost_to_followup" do
          choose "No"
        end

        submit_form
      end
    end
  end
end
