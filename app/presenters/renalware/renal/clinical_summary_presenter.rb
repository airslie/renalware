module Renalware
  module Renal
    class ClinicalSummaryPresenter
      rattr_initialize :patient

      # Host application may override the order or add other summary presenters
      def summary_parts(current_user)
        part_class_names = Renalware.config.page_layouts[:clinical_summary]
        part_class_names.each_with_object([]) do |class_name, arr|
          klass = class_name.constantize
          arr << if class_name.end_with?("Component")
                   klass.new(patient: patient, current_user: current_user)
                 else
                   klass.new(patient, current_user)
                 end
        end.select(&:render?)
      end
    end
  end
end
