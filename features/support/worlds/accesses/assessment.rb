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
            site: Renalware::Accesses::Site.first,
            type: access_type,
            by: user
          )
        )
      end

      # @section commands
      #
      def create_access_assessment(patient:,
                                   user:,
                                   site: Renalware::Accesses::Site.first,
                                   access_type: Renalware::Accesses::Type.first)

        patient = accesses_patient(patient)
        patient.assessments.create(
          valid_access_assessment_attributes.merge(
            site: site,
            type: access_type,
            by: user
          )
        )
      end

      def update_access_assessment(patient:, user:)
        travel_to 1.hour.from_now

        assessment = assessment_for(patient)
        assessment.update_attributes!(
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
                                  site: Renalware::Accesses::Site.first,
                                  access_type: Renalware::Accesses::Type.first)
        login_as user
        visit patient_accesses_dashboard_path(patient)
        within ".page-actions" do
          click_on "Add"
          click_on "Access Assessment"
        end

        fill_in "Performed", with: I18n.l(Time.zone.today)
        select(access_type.to_s, from: "Access Type") if access_type.present?
        select site.to_s, from: "Access Site"
        select "Right", from: "Access Side"

        within ".top" do
          click_on "Create"
        end
      end

      def update_access_assessment(patient:, user:)
        login_as user
        visit patient_accesses_dashboard_path(patient)
        within_article "Assessment History" do
          click_on "Edit"
        end

        select "Left", from: "Access Side"

        within ".top" do
          click_on "Save"
        end
      end
    end
  end
end
