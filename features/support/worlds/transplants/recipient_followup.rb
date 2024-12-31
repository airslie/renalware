module World
  module Transplants::RecipientFollowup
    module Domain
      # @section helpers
      #
      def recipient_followup_for(operation)
        operation.followup
      end

      def valid_recipient_followup_attributes
        {
          stent_removed_on: Time.zone.today,
          graft_function_onset: "immediate",
          last_post_transplant_dialysis_on: "2018-01-01",
          return_to_regular_dialysis_on: "2018-03-01",
          transplant_failed: false
        }
      end

      # @section seeding
      #
      def seed_recipient_followup(operation)
        Renalware::Transplants::RecipientFollowup.create!(
          valid_recipient_followup_attributes.merge(
            operation: operation
          )
        )
      end

      # @section commands
      #
      def create_recipient_followup(operation:, user:)
        Renalware::Transplants::RecipientFollowup.create(
          valid_recipient_followup_attributes.merge(
            operation_id: operation.id
          )
        )
      end

      def update_recipient_followup(operation:, user: nil)
        travel_to 1.hour.from_now

        operation = recipient_followup_for(operation)
        operation.update!(
          document: {},
          updated_at: Time.zone.now
        )
      end

      # @section expectations
      #
      def expect_recipient_followup_to_exist(operation)
        expect(operation.followup).to be_present
      end

      def expect_update_recipient_followup_to_succeed(operation:, user:)
        update_recipient_followup(operation: operation, user: user)
        followup = recipient_followup_for(operation)
        expect(followup).to be_modified
      end
    end

    module Web
      include Domain

      def create_recipient_followup(operation:, user:)
        login_as user
        visit patient_transplants_recipient_dashboard_path(operation.patient)
        within_article "Recipient Operations" do
          click_on "Enter details"
        end

        select "Immediate (1)", from: "Graft Function Onset"
        fill_in "Stent Removal Date", with: valid_recipient_followup_attributes[:stent_removed_on]
        fill_in "Date of last Dialysis Post-Transplant", with: "2018-12-01"
        fill_in "Date of Return to Regular Dialysis", with: "2019-02-01"

        within ".form-actions", match: :first do
          click_on t("btn.create")
        end
      end

      def update_recipient_followup(operation:, user:)
        login_as user
        visit patient_transplants_recipient_dashboard_path(operation.patient)
        within_article "Recipient Operations" do
          click_on t("btn.update")
        end

        within ".transplants_recipient_followup_transplant_failed" do
          choose "No"
        end

        within ".form-actions", match: :first do
          click_on t("btn.save")
        end
      end
    end
  end
end
