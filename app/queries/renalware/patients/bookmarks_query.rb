module Renalware
  module Patients
    class BookmarksQuery
      attr_reader :default_relation, :query

      def initialize(default_relation:, params: nil)
        @default_relation = default_relation
        @query = params || {}
        @query[:s] ||= "created_at desc"
      end

      def call
        search.result
      end

      # Note we *MUST* join onto patients for PatientsRansackHelper.identity_match to work.
      # It might be better to refactor PatientsRansackHelper so we can include where required
      # eg below using .extending(PatientsRansackHelper) rather than relying on it being in
      # included in the model file.
      # note that adding .includes(:created_by) here creates an ambiguous column
      # 'family_name' error
      def search
        @search ||= begin
          (default_relation || Bookmark)
            .extend(RansackScopes)
            .joins(:patient)
            .eager_load(patient: [current_modality: :description])
            .order(created_at: :desc)
            .ransack(query)
        end
      end

      module RansackScopes
        def self.extended(base)
          # Using a custom ransacker here in order to sort by modality description name
          # because using a predicate like  :patient_current_modality_description_name
          # results in an INNER JOIN onto modalities.
          base.ransacker :modality_desc do
            Arel.sql("modality_descriptions.name")
          end
        end
      end
    end
  end
end
