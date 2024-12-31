module Renalware
  module ProblemsHelper
    def problems_breadcrumb(patient)
      breadcrumb_for("Problems", patient_problems_path(patient))
    end

    def problem_breadcrumb(patient, problem)
      breadcrumb_for("Problem", patient_problem_path(patient, problem))
    end
  end
end
