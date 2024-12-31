module Renalware
  module HDHelper
    def hd_summary_breadcrumb(patient)
      breadcrumb_for("HD Summary", patient_hd_dashboard_path(patient))
    end

    def hd_profile_breadcrumb(patient)
      breadcrumb_for("HD Profile", patient_hd_current_profile_path(patient))
    end

    def hd_session_breadcrumb(session)
      breadcrumb_for(session_title(session), patient_hd_session_path(session.patient, session))
    end

    def session_title(session)
      I18n.t("renalware.hd.sessions_types.show.#{session.state}")
    end

    def session_edit_title(session)
      I18n.t("renalware.hd.sessions_types.edit.#{session.state}")
    end
  end
end
