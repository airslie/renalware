module World
  module Transplants::RecipientWorkup
    module Domain
      # @section helpers
      #
      def recipient_workup_for(patient)
        patient = transplant_patient(patient)

        Renalware::Transplants::RecipientWorkup.for_patient(patient).first_or_initialize
      end

      # @section seeding
      #
      def seed_recipient_workup_for(patient:, user: nil)
        patient = transplant_patient(patient)

        Renalware::Transplants::RecipientWorkup.create!(
          patient: patient,
          by: user
        )
      end

      # @section commands
      #
      def create_recipient_workup(patient:, user: nil)
        seed_recipient_workup_for(user: user, patient: patient)
      end

      def update_workup(patient:, user: nil)
        travel_to 1.hour.from_now

        workup = recipient_workup_for(patient)
        workup.update!(
          document: {
            historicals: {
              tb: "no"
            }
          },
          updated_at: Time.zone.now,
          by: user
        )
      end

      # @section expectations
      #
      def expect_recipient_workup_to_exist(patient)
        expect(Renalware::Transplants::RecipientWorkup.for_patient(patient)).to be_present
      end

      def expect_workup_to_be_modified(patient)
        workup = Renalware::Transplants::RecipientWorkup.for_patient(patient).first
        expect(workup).to be_modified
      end
    end

    module Web
      include Domain

      def create_recipient_workup(user:, patient:)
        login_as user
        visit patient_transplants_recipient_dashboard_path(patient)
        within ".page-actions" do
          click_on t("btn.add_")
          click_on "Recipient Workup"
        end

        within ".row.karnofsky" do
          all("input").first.set("66")
          all("input").last.set(Time.zone.today.to_s)
        end

        within ".row.prisma" do
          all("input").first.set("6")
          all("input").last.set(Time.zone.today.to_s)
        end

        within ".form-actions", match: :first do
          click_on t("btn.create")
        end

        expect(page).to have_current_path(patient_transplants_recipient_workup_path(patient))
      end

      def update_workup(patient:, user:)
        login_as user
        visit patient_transplants_recipient_workup_path(patient)
        click_on t("btn.edit")
        fill_in "Cervical smear result", with: "193"

        within ".form-actions", match: :first do
          click_on t("btn.save")
        end
      end
    end
  end
end
