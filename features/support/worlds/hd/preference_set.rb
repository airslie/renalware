module World
  module HD::PreferenceSet
    module Domain
      # @section helpers
      #
      def hd_preference_set_for(patient)
        patient = hd_patient(patient)

        Renalware::HD::PreferenceSet.for_patient(patient).first_or_initialize
      end

      # @section seeding
      #
      def seed_hd_preferences_for(patient, user:)
        patient = hd_patient(patient)

        Renalware::HD::PreferenceSet.create!(
          patient: patient,
          schedule_definition: Renalware::HD::ScheduleDefinition.first!,
          by: user
        )
      end

      # @section commands
      #
      def create_hd_preferences(user:, patient:)
        seed_hd_preferences_for(patient, user: user)
      end

      def update_hd_preferences(patient:, user: nil)
        travel_to 1.hour.from_now

        set = hd_preference_set_for(patient)
        set.update!(
          schedule_definition: Renalware::HD::ScheduleDefinition.last!,
          updated_at: Time.zone.now,
          by: user
        )
      end

      # @section expectations
      #
      def expect_hd_preferences_to_exist(patient)
        expect(Renalware::HD::PreferenceSet.for_patient(patient)).to be_present
      end
    end

    module Web
      include Domain

      def create_hd_preferences(user:, patient:)
        login_as user
        visit patient_hd_dashboard_path(patient)
        within ".page-actions" do
          click_on t("btn.add")
          click_on "HD Preferences"
        end

        select "Mon Wed Fri AM", from: "Schedule"

        submit_form
      end

      def update_hd_preferences(patient:, user:)
        login_as user
        visit patient_hd_dashboard_path(patient)

        within ".hd-preference-sets" do
          click_on t("btn.edit")
        end

        within ".document" do
          select "Mon Wed Fri PM", from: "Schedule"

          click_on t("btn.save")
        end
      end
    end
  end
end
