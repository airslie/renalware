module Renalware
  module PDHelper
    def pd_summary_breadcrumb(patient)
      breadcrumb_for("PD Summary", patient_pd_dashboard_path(patient))
    end

    def pd_assessment_breadcrumbs(patient, assessment)
      [
        pd_summary_breadcrumb(patient),
        pd_assessment_breadcrumb(patient, assessment)
      ]
    end

    def pd_assessment_breadcrumb(patient, assessment)
      breadcrumb_for("PD Assessment",
                     patient_pd_assessment_path(patient, assessment))
    end

    def pd_training_session_breadcrumbs(patient, training_session)
      [
        pd_summary_breadcrumb(patient),
        pd_training_session_breadcrumb(patient, training_session)
      ]
    end

    def pd_training_session_breadcrumb(patient, training_session)
      breadcrumb_for("PD Training Session",
                     patient_pd_training_session_path(patient, training_session))
    end
  end
end
