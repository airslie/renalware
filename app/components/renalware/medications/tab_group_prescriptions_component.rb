module Renalware
  module Medications
    # Renders tabs with tab (a tabbed prescriptions list component) for each of the supplied
    # drug types.
    class TabGroupPrescriptionsComponent < ApplicationComponent
      attr_reader :patient, :drug_type_names, :options

      def initialize(patient:, drug_type_names:, **options)
        @patient = patient
        @drug_type_names = Array(drug_type_names)
        @options = options
        super
      end

      def tab_data
        Drugs::Type.where(code: drug_type_names).map do |drug_type|
          {
            title: drug_type.name,
            prescriptions: prescriptions_for_drug_type(drug_type.code)
          }.merge(options)
        end
      end

      def call
        render TabbedPrescriptionsListComponent.new(tab_data)
      end

      private

      def prescriptions_for_drug_type(drug_type)
        Renalware::Medications::PrescriptionsQuery.new(
          relation: relation.having_drug_of_type(drug_type),
          apply_default_search_order: false # otherwise sorts by name first
        ).call
          .map { |prescrip| Renalware::Medications::PrescriptionPresenter.new(prescrip) }
      end

      def relation
        patient
          .prescriptions
          .with_created_by
          .with_medication_route
          .with_drugs
          .with_classifications
          .eager_load(drug: [:drug_types])
          .order(prescribed_on: :desc)
      end
    end
  end
end
