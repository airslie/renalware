module Renalware
  module Pathology
    class CreateObservationsGroupedByDateTable2
      attr_reader :patient, :code_group_name, :options, :per_page, :page, :request

      BlankRequest = Struct.new(:base_url, :path, :params, keyword_init: true)

      def initialize(patient:, code_group_name:, per_page: 25, page: 1, request: nil, **options)
        @patient = patient
        @code_group_name = code_group_name
        @options = options
        @per_page = per_page
        @page = page
        @request = request || BlankRequest.new(base_url: "", path: "", params: {})
      end

      def call
        create_observations_table
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
        relation = ObservationsGroupedByDate.where(group: code_group.name, patient_id: patient.id)
        pagy = Pagy::Offset.new(count: relation.count, limit: per_page, page: page, request:)
        [pagy, relation.offset(pagy.offset).limit(pagy.limit)]
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
