module Renalware
  module Pathology
    class HistoricalObservationResultsController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PatientCasting

      class FilterForm
        include ActiveModel::Model
        include ActiveModel::Attributes

        attribute :code_group

        delegate :name, to: :code_group, prefix: true
      end

      def index
        authorize pathology_patient

        render :index, locals: {
          table: observations_table,
          patient: pathology_patient,
          filter_form: FilterForm.new(code_group: code_group),
          code_group: code_group
        }
      end

      private

      def code_group_name
        params.dig(:filter_form, :code_group_name) || "default"
      end

      def code_group
        @code_group ||= CodeGroup.find_by!(name: code_group_name)
      end

      def observations_table
        CreateObservationsGroupedByDateTable2.new(
          patient: patient,
          code_group_name: code_group_name,
          page: params[:page] || 1,
          per_page: 25
        ).call
      end
    end
  end
end
