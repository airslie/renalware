module World
  module Transplants::Donation
    module Domain
      # @section helpers
      #
      def donation_for(patient)
        patient = transplant_patient(patient)

        Renalware::Transplants::Donation.for_patient(patient).first_or_initialize
      end

      def valid_donation_attributes
        {
          state: :volunteered,
          relationship_with_recipient: :son_or_daughter
        }
      end

      # @section seeding
      #
      def seed_donation(patient)
        patient = transplant_patient(patient)

        Renalware::Transplants::Donation.create!(
          valid_donation_attributes.merge(
            patient: patient
          )
        )
      end

      # @section commands
      #
      def create_donation(patient:, user:, state: nil)
        patient = transplant_patient(patient)

        Renalware::Transplants::Donation.create(
          valid_donation_attributes.merge(
            patient: patient,
            state: state
          )
        )
      end

      def update_donation(patient:, user: nil)
        travel_to 1.hour.from_now

        donation = donation_for(patient)
        donation.update!(
          updated_at: Time.zone.now
        )
      end

      def assign_recipient_to_donation(patient:, recipient:, user: nil)
        donation = donation_for(patient)
        donation.update!(
          recipient_id: recipient.id
        )
      end

      # @section expectations
      #
      def expect_donation_to_exist(patient)
        expect(Renalware::Transplants::Donation.for_patient(patient)).to be_present
      end

      def expect_update_donation_to_succeed(patient:, user:)
        update_donation(patient: patient, user: user)
        donation = donation_for(patient)
        expect(donation).to be_modified
      end

      def expect_donation_to_be_refused
        expect(Renalware::Transplants::Donation.count).to eq(0)
      end

      def expect_transplant_donation_as_recipient(patient:, recipient:)
        donation = donation_for(patient)
        expect(donation.recipient_id).to eq(recipient.id)
      end
    end

    module Web
      include Domain

      def create_donation(user:, patient:, state: nil)
        login_as user
        visit patient_transplants_donor_dashboard_path(patient)
        within ".page-heading" do
          click_on t("btn.add_")
          click_on "Donation"
        end

        begin
          find("option[value='#{state}']").select_option
          select "Son or daughter", from: "Relationship With Recipient"
        rescue Capybara::ElementNotFound
        end

        within ".form-actions", match: :first do
          click_on t("btn.create")
        end
      end

      def update_donation(patient:, user:)
        login_as user
        visit patient_transplants_donor_dashboard_path(patient)
        within_article "Donation" do
          click_on t("btn.edit")
        end

        select "Seen in Clinic", from: "State"

        within ".form-actions", match: :first do
          click_on t("btn.save")
        end
      end

      # rubocop:disable Layout/LineLength
      def assign_recipient_to_donation(patient:, recipient:, user:)
        login_as user
        visit patient_transplants_donor_dashboard_path(patient)
        within_article "Donation" do
          click_on t("btn.edit")
        end

        # Until we work how to test a select2 ajax autocomplete, for now insert the
        # anticipated <option> into the select.
        #   select2(recipient.family_name, from: "transplants_donation_recipient_id")
        page.execute_script(
          %"$('#transplants_donation_recipient_id').html('<option value=\"#{recipient.id}\">Patty</option>')"
        )
        wait_for_ajax

        # within ".form-actions", match: :first do
        #   click_on t("btn.update")
        # end
        submit_form
        expect(page).to have_current_path(patient_transplants_donor_dashboard_path(patient))
      end
      # rubocop:enable Layout/LineLength
    end
  end
end
