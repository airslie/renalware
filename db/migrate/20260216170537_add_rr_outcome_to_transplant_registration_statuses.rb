class AddRrOutcomeToTransplantRegistrationStatuses < ActiveRecord::Migration[8.1]
  def up
    within_renalware_schema do
      safety_assured do
        add_column :transplant_registration_status_descriptions,
                   :ukrdc_assessment_outcome_code,
                   :integer,
                   comment: "See UKRR Dataset 5+. Valid values are 1 through 3."

        add_foreign_key :transplant_registration_status_descriptions,
                        :ukrdc_assessment_outcomes,
                        column: :ukrdc_assessment_outcome_code,
                        primary_key: :code

        {
          active: 3,
          suspended: 1,
          transplanted: 3,
          live_transplanted: 3,
          off_by_patient: 1,
          not_eligible: 1,
          unfit_reconsider: 1,
          unfit_permanent: 1,
          working_up: 2,
          working_up_lrf: 2,
          not_for_work_up: 1,
          workup_complete: 3,
          transfer_out: 1,
          died: 1
        }.each do |reg_status_code, rr_outcome_code|
          Renalware::Transplants::RegistrationStatusDescription.transaction do
            Renalware::Transplants::RegistrationStatusDescription
              .find_by(code: reg_status_code)
              .presence&.update!(ukrdc_assessment_outcome_code: rr_outcome_code)
          end
        end
      end
    end
  end

  def down
    within_renalware_schema do
      remove_column :transplant_registration_status_descriptions, :ukrdc_assessment_outcome_code
    end
  end
end
