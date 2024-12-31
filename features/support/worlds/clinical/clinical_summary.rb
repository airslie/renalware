module World
  module Clinical
    module Domain
      def review_clinical_summary(patient:, user:)
        Renalware::Renal::ClinicalSummaryPresenter.new(patient)
      end
    end

    module Web
      include Domain

      def review_clinical_summary(patient:, user:)
        login_as user

        visit patient_clinical_summary_path(patient)

        current_prescriptions = html_table_to_array("current-prescriptions").drop(1)
        current_problems = html_list_to_array("current-problems")

        OpenStruct.new(
          current_prescriptions: current_prescriptions,
          current_problems: current_problems
        )
      end
    end
  end
end
