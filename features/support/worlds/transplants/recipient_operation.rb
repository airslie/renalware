module World
  module Transplants::RecipientOperation
    module Domain
      # @section helpers
      #
      def recipient_operation_for(patient)
        Renalware::Transplants::RecipientOperation.for_patient(patient).first_or_initialize
      end

      def valid_recipient_operation_attributes
        {
          performed_on: fake_date,
          theatre_case_start_time: fake_time,
          donor_kidney_removed_from_ice_at: fake_date_time,
          operation_type: "kidney",
          hospital_centre: transplant_hospital,
          kidney_perfused_with_blood_at: fake_date_time,
          cold_ischaemic_time: fake_time,
          warm_ischaemic_time: fake_time,
          document: {
            donor: {
              age: {
                amount: 11,
                unit: "months"
              }
            }
          }
        }
      end

      # @section seeding
      #
      def seed_recipient_operation(patient, params = {})
        patient = transplant_patient(patient)

        operation_attributes = valid_recipient_operation_attributes.merge(patient: patient)
        params.each { |key, value| operation_attributes[key] = value }

        Renalware::Transplants::RecipientOperation.create!(operation_attributes)
      end

      # @section commands
      #
      def create_recipient_operation(patient:, user:, performed_on:, age:)
        patient = transplant_patient(patient)
        Renalware::Transplants::RecipientOperation.create!(
          valid_recipient_operation_attributes.merge(
            patient: patient,
            performed_on: performed_on,
            document: {
              donor: {
                type: "live_related",
                relationship: "mother",
                age: {
                  amount: age
                }
              }
            }
          )
        )
      end

      def update_recipient_operation(patient:, age:, user: nil)
        travel_to 1.hour.from_now

        operation = recipient_operation_for(patient)
        operation.update!(
          document: {
            donor: {
              age: {
                amount: age,
                unit: "years"
              }
            }
          },
          updated_at: Time.zone.now
        )
      end

      # @section expectations
      #
      def expect_recipient_operation_to_exist(patient, age:)
        operation = Renalware::Transplants::RecipientOperation.for_patient(patient).first
        expect(operation).to be_present
        expect(operation.document.donor.age.amount).to eq(age)
        expect(operation.document.donor.type).to eq("live_related")
        expect(operation.document.donor.relationship).to eq("mother")
      end

      def expect_update_recipient_operation_to_succeed(patient:, user:)
        update_recipient_operation(patient: patient, user: user, age: 52)
        operation = recipient_operation_for(patient)
        expect(operation).to be_modified
        expect(operation.document.donor.age.amount).to eq(52)
      end

      def expect_recipient_operation_to_be_refused
        expect(Renalware::Transplants::RecipientOperation.count).to eq(0)
      end
    end

    module Web
      include Domain

      def create_recipient_operation(user:, patient:, performed_on:, age:)
        login_as user
        visit patient_transplants_recipient_dashboard_path(patient)
        within ".page-actions" do
          click_on t("btn.add_")
          click_on "Recipient Operation"
        end

        select "Kidney only", from: "Operation Type"
        fill_in "Operation Date", with: performed_on
        fill_in "Theatre Case Start Time", with: fake_time
        fill_in "Donor Kidney Removed From Ice At", with: fake_time
        select transplant_hospital.name, from: "Transplant Site"
        fill_in "Kidney Perfused With Blood At", with: fake_time
        fill_in "Cold Ischaemic Time", with: fake_time
        fill_in "Warm Ischaemic Time", with: fake_time
        select "Live related", from: "Donor Type"
        select "Mother", from: "Relationship"
        find("#transplants_recipient_operation_document_donor_age_amount").set(age)
        select "years", from: "transplants_recipient_operation_document_donor_age_unit"

        within ".form-actions", match: :first do
          click_on t("btn.create")
        end
      end

      def update_recipient_operation(patient:, user:, age:)
        login_as user
        visit patient_transplants_recipient_dashboard_path(patient)
        within_article "Recipient Operations" do
          click_on t("btn.edit")
        end

        select "Pancreas only", from: "Operation Type"
        find("#transplants_recipient_operation_document_donor_age_amount").set(age)
        select "years", from: "transplants_recipient_operation_document_donor_age_unit"

        within ".form-actions", match: :first do
          click_on t("btn.save")
        end
      end
    end
  end
end
