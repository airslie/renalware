module Renalware
  module Patients
    class AttachmentQuery
      attr_reader :patient, :default_relation, :query

      def initialize(patient:, params: nil)
        @patient = patient
        @query = params || {}
        @query[:s] ||= "created_at desc"
      end

      def call
        search.result
      end

      # Note we must use .eager_load(:patient) here to force an inner join onto patients;
      # without this, when sorting by, say file_blob_byte_size (ie the active storage blob)
      # we can end up getting back soft-deleted attachments with a non-null deleted_at datetime.
      def search
        @search ||= begin
          patient.attachments
            .order(created_at: :desc)
            .eager_load(:patient)
            .ransack(query)
        end
      end
    end
  end
end
