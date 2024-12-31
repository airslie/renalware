module World
  module Accesses::Procedure
    module Domain
      # @section helpers
      #
      def procedure_for(patient)
        patient = accesses_patient(patient)
        patient.procedures.first_or_initialize
      end

      def valid_access_procedure_attributes
        {
          performed_on: Time.zone.today,
          performed_by: Renalware::User.first,
          side: :left,
          pd_catheter_insertion_technique: Renalware::Accesses::CatheterInsertionTechnique.first
        }
      end

      # @section seeding
      #
      def seed_access_procedure_for(patient, user:)
        patient = accesses_patient(patient)
        patient.procedures.create!(
          valid_access_procedure_attributes.merge(
            type: Renalware::Accesses::Type.first,
            by: user
          )
        )
      end

      # @section commands
      #
      def create_access_procedure(patient:,
                                  user:,
                                  access_type: Renalware::Accesses::Type.first)
        patient = accesses_patient(patient)
        patient.procedures.create(
          valid_access_procedure_attributes.merge(
            type: access_type,
            by: user
          )
        )
      end

      def update_access_procedure(patient:, user:)
        travel_to 1.hour.from_now

        procedure = procedure_for(patient)
        procedure.update!(
          updated_at: Time.zone.now,
          first_used_on: Time.zone.today,
          by: user
        )
      end

      # @section expectations
      #
      def expect_access_procedure_to_exist(patient)
        patient = accesses_patient(patient)
        expect(patient.procedures).to be_present
      end

      def expect_access_procedure_to_be_refused
        expect(Renalware::Accesses::Procedure.count).to eq(0)
      end
    end

    module Web
      include Domain

      def create_access_procedure(user:,
                                  patient:,
                                  access_type: Renalware::Accesses::Type.first)
        login_as user
        visit patient_accesses_dashboard_path(patient)
        within(".page-actions") do
          click_on t("btn.add_")
          click_on "Access Procedure"
        end

        fill_in "Performed On", with: l(Time.zone.today)
        fill_in "Performed By", with: user.to_s
        select(access_type.to_s, from: "Access Procedure") if access_type.present?
        select "Right", from: "Access Side"
        select "Laparoscopic", from: "PD Catheter Insertion Technique"

        within ".form-actions", match: :first do
          click_on t("btn.create")
        end
      end

      def update_access_procedure(patient:, user:)
        login_as user
        visit patient_accesses_dashboard_path(patient)
        within_article "Procedure History" do
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
