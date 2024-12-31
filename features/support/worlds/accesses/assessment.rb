module World
  module Accesses::Assessment
    module Domain
      # @section helpers
      #
      def assessment_for(patient)
        patient = accesses_patient(patient)
        patient.assessments.first_or_initialize
      end

      def valid_access_assessment_attributes
        {
          performed_on: Time.zone.today,
          side: :left,
          document: {
            results: {
              method: :hand_doppler
            }
          }
        }
      end

      # @section seeding
      #
      def seed_access_assessment_for(patient,
                                     user:,
                                     access_type: Renalware::Accesses::Type.first)
        patient = accesses_patient(patient)
        patient.assessments.create!(
          valid_access_assessment_attributes.merge(
            type: access_type,
            by: user
          )
        )
      end

      # @section commands
      #
      def create_access_assessment(patient:,
                                   user:,
                                   access_type: Renalware::Accesses::Type.first)
        patient = accesses_patient(patient)
        patient.assessments.create(
          valid_access_assessment_attributes.merge(
            type: access_type,
            by: user
          )
        )
      end

      def update_access_assessment(patient:, user:)
        travel_to 1.hour.from_now

        assessment = assessment_for(patient)
        assessment.update!(
          updated_at: Time.zone.now,
          procedure_on: Time.zone.today,
          by: user
        )
      end

      # @section expectations
      #
      def expect_access_assessment_to_exist(patient)
        patient = accesses_patient(patient)
        expect(patient.assessments).to be_present
      end

      def expect_access_assessment_to_be_refused
        expect(Renalware::Accesses::Assessment.count).to eq(0)
      end
    end

    module Web
      include Domain

      def create_access_assessment(user:,
                                   patient:,
                                   access_type: Renalware::Accesses::Type.first)
        login_as user
        visit patient_accesses_dashboard_path(patient)
        within ".page-actions" do
          click_on t("btn.add_")
          click_on "Access Assessment"
        end

        fill_in "Performed", with: l(Time.zone.today)
        select(access_type.to_s, from: "Access Type") if access_type.present?
        select "Right", from: "Access Side"

        within ".form-actions", match: :first do
          click_on t("btn.create")
        end
      end

      def update_access_assessment(patient:, user:)
        login_as user
        visit patient_accesses_dashboard_path(patient)
        within_article "Assessment History" do
          click_on t("btn.edit")
        end

        select "Left", from: "Access Side"

        within ".form-actions", match: :first do
          click_on t("btn.save")
        end
      end
    end
  end
end
