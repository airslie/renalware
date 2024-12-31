module Renalware
  module UKRDC
    class ExportSummary
      attr_accessor_initialize [
        :milliseconds_taken,
        :num_changed_patients,
        :results,
        :archive_folder,
        :count_of_files_in_outgoing_folder
      ]

      def elapsed_time
        (milliseconds_taken.to_f / 1000.0).round(2)
      end

      class Serializer < ActiveJob::Serializers::ObjectSerializer
        def serialize?(argument)
          argument.kind_of?(ExportSummary) # rubocop:disable Style/ClassCheck
        end

        def serialize(summary)
          super(
            "milliseconds_taken" => summary.milliseconds_taken,
            "num_changed_patients" => summary.num_changed_patients,
            "results" => summary.results,
            "archive_folder" => summary.archive_folder,
            "count_of_files_in_outgoing_folder" => summary.count_of_files_in_outgoing_folder
          )
        end

        def deserialize(hash)
          ExportSummary.new(
            milliseconds_taken: hash["milliseconds_taken"],
            num_changed_patients: hash["num_changed_patients"],
            results: hash["results"],
            archive_folder: hash["archive_folder"],
            count_of_files_in_outgoing_folder: hash["count_of_files_in_outgoing_folder"]
          )
        end
      end
    end
  end
end
