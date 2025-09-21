module Renalware
  module Patients
    class MergeJob < ApplicationJob
      queue_as :feeds

      def perform(merge_id)
        Renalware::Patients::Merge.find(merge_id).perform!
      rescue ActiveRecord::RecordNotFound
        Rails.logger.error("Renalware::Patients::Merge with ID #{merge_id} not found")
      end
    end
  end
end
