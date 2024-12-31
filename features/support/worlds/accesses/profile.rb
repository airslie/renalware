module World
  module Accesses::Profile
    module Domain
      # @section helpers
      #
      def profile_for(patient)
        patient = accesses_patient(patient)
        patient.profiles.first_or_initialize
      end

      def valid_access_profile_attributes
        {
          formed_on: Time.zone.today,
          type: Renalware::Accesses::Type.first,
          side: :left
        }
      end

      # @section seeding
      #
      def seed_access_profile_for(patient, user:)
        patient = accesses_patient(patient)
        patient.profiles.create!(
          valid_access_profile_attributes.merge(
            by: user
          )
        )
      end

      # @section commands
      #
      def create_access_profile(patient:, user:, side: :left)
        patient = accesses_patient(patient)
        patient.profiles.create(
          valid_access_profile_attributes.merge(
            side: side,
            by: user
          )
        )
      end

      def update_access_profile(patient:, user:)
        travel_to 1.hour.from_now

        profile = profile_for(patient)
        profile.update!(
          updated_at: Time.zone.now,
          started_on: Time.zone.today,
          by: user
        )
      end

      # @section expectations
      #
      def expect_access_profile_to_exist(patient)
        patient = accesses_patient(patient)
        expect(patient.profiles).to be_present
      end

      def expect_access_profile_to_be_refused
        expect(Renalware::Accesses::Profile.count).to eq(0)
      end
    end

    module Web
      include Domain

      def create_access_profile(user:, patient:, side: "Right")
        login_as user
        visit patient_accesses_dashboard_path(patient)
        within ".page-actions" do
          click_on t("btn.add_")
          click_on "Access Profile"
        end

        fill_in "Formed On", with: l(Time.zone.today)
        select "Tunnelled subcl", from: "Access Type"
        select(side.to_s.camelcase, from: "Access Side") if side.present?

        within ".form-actions", match: :first do
          click_on t("btn.create")
        end
      end

      # Note that if the profile has a start date <= today if will appear in the
      # article called Current Access Profile. Otherwise it will be inside an
      # article calle Acc Profile History
      def update_access_profile(patient:, user:)
        login_as user
        visit patient_accesses_dashboard_path(patient)
        # Capybara::Screenshot.screenshot_and_save_page

        within_article "Access Profile History" do
          click_on t("btn.edit")
        end

        select "Left", from: "Access Side"

        submit_form
      end
    end
  end
end
