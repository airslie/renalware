module World
  module HD::Profile
    module Domain
      # @section helpers
      #
      def hd_profile_for(patient)
        Renalware::HD::Profile.for_patient(patient).first_or_initialize
      end

      def valid_profile_attributes
        {
          schedule: :mon_wed_fri_am,
          document: {
            transport: {
              type: :car
            }
          }
        }
      end

      # @section set-ups
      #
      def set_up_hd_profile_for(patient, prescriber)
        Renalware::HD::Profile.create!(
          valid_profile_attributes.merge(
            patient: patient,
            prescriber: prescriber
          )
        )
      end

      # @section commands
      #
      def create_hd_profile(user: nil, patient:, prescriber:)
        Renalware::HD::Profile.create(
          valid_profile_attributes.merge(
            patient: patient,
            prescriber: prescriber
          )
        )
      end

      def update_hd_profile(patient:, user: nil)
        travel_to 1.hour.from_now

        profile = hd_profile_for(patient)
        profile.update_attributes!(
          updated_at: Time.zone.now,
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

      def expect_hd_profile_to_be_modified(patient)
        profile = Renalware::HD::Profile.for_patient(patient).first
        expect(profile).to be_modified
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
        click_on "Enter profile"

        select "Mon, Wed, Fri AM", from: "Schedule"
        select prescriber.full_name, from: "Prescriber" if prescriber
        select "300", from: "Flow Rate"

        within ".top" do
          click_on "Save"
        end
      end

      def update_hd_profile(patient:, user:, prescriber: nil)
        login_as user
        visit patient_hd_dashboard_path(patient)
        click_on "Edit"

        select "Mon, Wed, Fri PM", from: "Schedule"
        select "400", from: "Flow Rate"

        within ".top" do
          click_on "Save"
        end
      end
    end
  end
end
