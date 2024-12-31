module World
  module HD::Profile
    module Domain
      # @section helpers
      #
      def hd_profile_for(patient)
        patient = hd_patient(patient)

        Renalware::HD::Profile.for_patient(patient).first_or_initialize
      end

      def valid_profile_attributes
        {
          schedule_definition: Renalware::HD::ScheduleDefinition.first!,
          hospital_unit: Renalware::Hospitals::Unit.first!,
          document: {
            transport: {
              type: :car
            }
          }
        }
      end

      # @section seeding
      #
      def seed_hd_profile_for(patient, prescriber:)
        patient = hd_patient(patient)

        Renalware::HD::Profile.create!(
          valid_profile_attributes.merge(
            patient: patient,
            prescriber: prescriber,
            by: prescriber
          )
        )
      end

      # @section commands
      #
      def create_hd_profile(patient:, prescriber:, user: nil)
        patient = hd_patient(patient)

        Renalware::HD::Profile.create(
          valid_profile_attributes.merge(
            patient: patient,
            prescriber: prescriber,
            by: prescriber
          )
        )
      end

      def update_hd_profile(patient:, user:)
        travel_to 1.hour.from_now

        profile = hd_profile_for(patient)
        profile.update!(
          updated_at: Time.zone.now,
          by: user,
          document: {
            transport: {
              type: :taxi
            }
          }
        )
      end

      # @section expectations
      #
      def expect_hd_profile_to_exist(patient)
        expect(Renalware::HD::Profile.for_patient(patient)).to be_present
      end

      def expect_hd_profile_to_be_refused
        expect(Renalware::HD::Profile.count).to eq(0)
      end
    end

    module Web
      include Domain

      def create_hd_profile(user:, patient:, prescriber:)
        login_as user
        visit patient_hd_dashboard_path(patient)

        within ".page-actions" do
          click_on t("btn.add")
          click_on "HD Profile"
        end

        select "Mon Wed Fri AM", from: "Schedule"
        select prescriber.to_s, from: "Prescriber" if prescriber
        select "300", from: "Flow Rate"

        within ".form-actions", match: :first do
          click_on t("btn.create")
        end
      end

      def update_hd_profile(patient:, user:, prescriber: nil)
        login_as user
        visit patient_hd_dashboard_path(patient)

        within ".hd-profile-summary" do
          click_on t("btn.edit")
        end

        select "Mon Wed Fri PM", from: "Schedule"
        select "400", from: "Flow Rate"

        within ".form-actions", match: :first do
          click_on t("btn.save")
        end
      end
    end
  end
end
