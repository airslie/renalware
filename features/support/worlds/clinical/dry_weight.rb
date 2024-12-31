module World
  module Clinical::DryWeight
    module Domain
      # @section helpers
      #
      def hd_dry_weight_for(patient)
        patient = hd_patient(patient)

        Renalware::Clinical::DryWeight.for_patient(patient).first_or_initialize
      end

      def valid_dry_weight_attributes
        {
          weight: 90,
          assessed_on: Time.zone.today
        }
      end

      # @section seeding
      #
      def seed_dry_weight_for(patient, assessor)
        patient = hd_patient(patient)

        Renalware::Clinical::DryWeight.create!(
          valid_dry_weight_attributes.merge(
            patient: patient,
            assessor: assessor,
            by: assessor
          )
        )
      end

      # @section commands
      #
      def create_dry_weight(patient:, assessed_on:, user: nil)
        patient = clinical_patient(patient)

        Renalware::Clinical::DryWeight.create(
          valid_dry_weight_attributes.merge(
            patient: patient,
            assessor: user,
            assessed_on: assessed_on,
            by: user
          )
        )
      end

      def update_hd_dry_weight(patient:, user:)
        travel_to 1.hour.from_now

        profile = hd_dry_weight_for(patient)
        profile.update!(
          updated_at: Time.zone.now,
          by: user
        )
      end

      # @section expectations
      #
      def expect_dry_weight_to_exist(patient)
        expect(Renalware::Clinical::DryWeight.for_patient(patient)).to be_present
      end

      def expect_dry_weight_to_be_modified(patient)
        profile = Renalware::Clinical::DryWeight.for_patient(patient).first
        expect(profile).to be_modified
      end

      def expect_dry_weight_to_be_refused(_patient)
        expect(Renalware::Clinical::DryWeight.count).to eq(0)
      end
    end

    module Web
      include Domain

      def create_dry_weight(user:, patient:, assessed_on:)
        login_as user
        visit patient_hd_dashboard_path(patient)

        within "article.dry-weights" do
          click_on t("btn.add")
        end

        fill_in "Dry Weight", with: 98
        fill_in "Assessment Date", with: assessed_on || ""

        submit_form
      end

      def expect_dry_weight_to_exist(patient)
        expect(page).to have_current_path(patient_hd_dashboard_path(patient))
        expect(Renalware::Clinical::DryWeight.for_patient(patient)).to be_present
      end
    end
  end
end
