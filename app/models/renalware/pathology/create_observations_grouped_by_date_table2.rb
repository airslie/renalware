module Renalware
  module Pathology
    class CreateObservationsGroupedByDateTable2
      include Pagy::Backend

      attr_reader :patient, :code_group_name, :options, :per_page, :page

      def initialize(patient:, code_group_name:, per_page: 25, page: 1, **options)
        @patient = patient
        @code_group_name = code_group_name
        @options = options
        @per_page = per_page
        @page = page
      end

      def call
        create_observations_table
      end

      def params
        {}
      end

      private

      def create_observations_table
        pagy, obs = observations
        ObservationsGroupedByDateTable2.new(
          relation: obs,
          observation_descriptions: code_group.observation_descriptions,
          pagy: pagy
        )
      end

      # NB: does not actually group results by date but returns a row for each observed_at datetime.
      def observations
        pagy(
          ObservationsGroupedByDate.where(group: code_group.name, patient_id: patient.id),
          items: per_page,
          page: page
        )
      end

      # code_group_name might be eg :pd_mdm so we try and find it but the hospital might not
      # have defined it in which case we use the default group.
      def code_group
        @code_group ||= begin
          CodeGroup.find_by(name: code_group_name) || CodeGroup.find_by!(name: "default")
        end
      end
    end
  end
end
