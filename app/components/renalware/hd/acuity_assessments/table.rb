# frozen_string_literal: true

module Renalware
  class HD::AcuityAssessments::Table < Shared::Table
    RATIOS = {
      0.25 => { label: "1:4", color: "bg-green-300" },
      0.33 => { label: "1:3", color: "bg-lime-900" },
      0.50 => { label: "1:2", color: "bg-orange-500" },
      1.00 => { label: "1:1", color: "bg-red-600" }
    }.freeze

    COLORS = RATIOS.transform_values { |_label, color| color }.freeze

    def initialize(assessments:, pagy:, current_user:)
      @assessments = assessments
      @pagy = pagy
      @current_user = current_user
      super(class: "hd-acuity-assessments")
    end

    def view_template
      super do
        table_header
        TableBody do
          assessments.each { row(it) }
        end
      end
      raw(pagy.series_nav.html_safe) if pagy && pagy.pages > 1
    end

    private

    attr_reader :assessments, :pagy, :current_user

    def row(assessment)
      ratio = RATIOS[assessment.ratio.to_f]
      TableRow do
        TableCell { DeleteLink(path: assessment_path(assessment), policy: policy(assessment)) }
        TableCell { Badge(**ratio, class: "text-center") }
        DateCell(assessment.created_at)
        TableCell { assessment.created_by.to_s }
      end
    end

    def table_header
      TableHeader do
        TableRow do
          TableHead(class: %w(noprint w-5))
          TableHead(class: %w(col-width-small)) { "Ratio" }
          DateHead()
          TableHead { "Assessor" }
        end
      end
    end

    def assessment_path(assessment)
      patient_hd_acuity_assessment_path(assessment.patient, assessment)
    end

    def policy(assessment)
      Renalware::HD::AcuityAssessmentPolicy.new(current_user, assessment)
    end
  end
end
