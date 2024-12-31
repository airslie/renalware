module Renalware
  module Pathology
    class CurrentObservationResultsController < BaseController
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

        observation_set = ObservationSetPresenter.new(
          pathology_patient.fetch_current_observation_set,
          code_group_name: code_group_name
        )
        render :index,
               locals: {
                 observation_set: observation_set,
                 patient: pathology_patient,
                 filter_form: FilterForm.new(code_group: code_group)
               }
      end

      def code_group_name
        params.dig(:filter_form, :code_group_name) || "default"
      end

      def code_group
        @code_group ||= CodeGroup.find_by!(name: code_group_name)
      end
    end
  end
end
