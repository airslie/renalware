module Renalware
  module TransplantHelper
    def donor_summary_breadcrumb(patient)
      breadcrumb_for("Transplant Donor Summary",
                     patient_transplants_donor_dashboard_path(patient))
    end

    def donor_workup_breadcrumb(patient)
      breadcrumb_for("Workup", patient_transplants_donor_workup_path(patient))
    end

    def donor_operation_breadcrumb(patient, operation, with_timestamp: false)
      title = "Donor Operation"
      title += " #{l(operation.performed_on)}" if with_timestamp
      breadcrumb_for(title, patient_transplants_donor_operation_path(patient, operation))
    end

    def donor_donation_breadcrumb(patient, donation)
      breadcrumb_for("Donation", patient_transplants_donation_path(patient, donation))
    end

    def recipient_summary_breadcrumb(patient)
      breadcrumb_for("Transplant Recipient Summary",
                     patient_transplants_recipient_dashboard_path(patient))
    end

    def recipient_operation_breadcrumb(patient, operation)
      breadcrumb_for("Recipient Operation",
                     patient_transplants_recipient_operation_path(patient, operation))
    end

    def recipient_operation_breadcrumbs(patient, operation)
      [
        recipient_summary_breadcrumb(patient),
        recipient_operation_breadcrumb(patient, operation)
      ]
    end

    def recipient_workup_breadcrumb(patient, workup)
      breadcrumb_for("Recipient Workup",
                     patient_transplants_recipient_workup_path(patient, workup))
    end

    def recipient_workup_breadcrumbs(patient, workup)
      [
        recipient_summary_breadcrumb(patient),
        recipient_workup_breadcrumb(patient, workup)
      ]
    end

    def recipient_wait_list_breadcrumbs(patient)
      [
        recipient_summary_breadcrumb(patient),
        breadcrumb_for("Wait List Registration", patient_transplants_registration_path(patient))
      ]
    end

    def recipient_followup_breadcrumbs(patient, followup)
      [
        recipient_summary_breadcrumb(patient),
        breadcrumb_for(
          recipient_followup_title(followup),
          patient_transplants_recipient_operation_followup_path(patient, followup.operation)
        )
      ]
    end

    def recipient_followup_title(followup)
      "Operation (#{l(followup.operation.performed_on)}) Followup"
    end
  end
end
