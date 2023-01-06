# frozen_string_literal: true

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
    end
  end
end
