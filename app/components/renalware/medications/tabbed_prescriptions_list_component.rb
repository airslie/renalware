module Renalware
  module Medications
    # Accepts a group of prescriptions -  see example usage - and renders a tabs for each of the
    # group names with their corresponding tabular content.
    # Various options - see PrescriptionGroup - drive what columns are shown.
    #
    # Example usage:
    #
    # = render Renalware::Medications::TabbedPrescriptionsListComponent.new(
    #   [
    #      { title: "Current", prescriptions: list1, show_administer_on_hd: true },
    #      { title: "EPO", prescriptions: list2, show_terminated_on: true }
    #   ]
    class TabbedPrescriptionsListComponent < ApplicationComponent
      attr_reader :groups

      class PrescriptionGroup
        attr_reader_initialize [
          :title,
          :prescriptions,
          show_terminated_on: true,
          show_administer_on_hd: true,
          show_drug_types: false
        ]

        # The markup expects each prescription to have been decorated with a PrescriptionPresenter.
        # However there may be cases where they might have been, so we check by
        # (looking for a method which is defined by the presenter) and decorate them if necessary.
        def prescriptions
          @prescriptions.map do |presc|
            presc.respond_to?(:drug_type_names) ? presc : PrescriptionPresenter.new(presc)
          end
        end
      end

      # Map the incoming array of hashes to an array of PrescriptionGroup objects to make
      # interrogation easier in the html.
      def initialize(prescription_groups)
        @groups = Array(prescription_groups).map { |options| PrescriptionGroup.new(options) }
        super
      end
    end
  end
end
